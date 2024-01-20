//
//  NetworkSampleViewModel.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/16.
//

import Combine
import Foundation

// MARK: - NetworkSampleViewModel

class NetworkSampleViewModel {

    enum FetchState {
        case loading
        case success
        case failed(error: Error)
        case none
    }

    // MARK: Lifecycle

    init() {
        $searchTerm
            .debounce(for: 0.5, scheduler: RunLoop.main) // 延遲觸發搜索操作(0.5s)
            .removeDuplicates() // 避免在使用者輸入相同的搜索文字時重複執行搜索操作
            .sink { [weak self] term in
                self?.searchTrack(with: term)
            }.store(in: &cancellables)
    }

    // MARK: Internal

    private(set) var selectedTrack: Track?

    @Published var searchTerm: String = ""
    @Published var state: FetchState = .none

    var totalCount: Int {
        tracks.count
    }

    func track(forCellAt index: Int) -> Track? {
        guard tracks.indices.contains(index) else { return nil }
        return tracks[index]
    }

    func fetchTracks() {
        tracks.removeAll()

        guard !searchTerm.isEmpty else {
            state = .success
            return
        }

        // 避免同時載入多次
        if case .loading = state { return }
        state = .loading

        let offset = currentPage * pageSize
        let request = SearchRequest(term: searchTerm, limit: pageSize, offset: offset)

        Task {
            do {
                let response = try await fetchDataByURLSession(request: request)
                self.currentPage += 1
                self.totalPages = response.resultCount / self.pageSize + 1
                self.tracks.append(contentsOf: response.results.map { $0.convertToTrack() })
                // 如果資料的數量小於每頁的大小，表示已經下載完所有資料
                self.hasMoreData = response.resultCount == self.pageSize
                DispatchQueue.main.async {
                    self.state = .success
                }
            } catch {
                DispatchQueue.main.async {
                    self.state = .failed(error: error)
                }
            }
        }
    }

    func fetchDataByURLSession(request: SearchRequest) async throws -> SearchResponse  {
        let request = try request.buildRequest()

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ResponseError.nonHTTPResponse
        }

        return try JSONDecoder().decode(SearchResponse.self, from: data)
    }

    func fetchByPublisher() {
        //        guard let request = try? self.buildRequest(),
        //              let url = request.url else {
        //            return Fail(error: RequestError.urlError)
        //                .eraseToAnyPublisher()
        //        }
        //
        //        return URLSession.shared.dataTaskPublisher(for: url)
        //                   .map { $0.data }
        //                   .decode(type: SearchResponse.self, decoder: JSONDecoder())
        //                   .map { $0.results.map { $0.convertToTrack() } }
        //                   .mapError { error -> Error in
        //                       switch error {
        //                       case is URLError:
        //                           return ResponseError.nilData
        //                       default:
        //                           return ResponseError.nonHTTPResponse
        //                       }
        //                   }
        //                   .eraseToAnyPublisher()
        //    }
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = .init()
    private var tracks: [Track] = []
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private var pageSize: Int = 20
    private var hasMoreData: Bool = true

    // TODO: 搜尋某些字詞 ex: de 會壞掉
    // 回傳404，錯誤訊息 Your request produced an error. [newNullResponse]
    private func searchTrack(with term: String) {
        searchTerm = term
        fetchTracks()
    }
}
