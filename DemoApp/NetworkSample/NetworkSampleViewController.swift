//
//  NetworkSampleViewController.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/16.
//

import UIKit
import Combine

class NetworkSampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private let viewModel: NetworkSampleViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    private let cellHeight: CGFloat = 60

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .appColor(.gray3)
        searchController.searchBar.barTintColor = .appColor(.gray3)
        // 文字顏色
        searchController.searchBar.barStyle = .default
        // 搜尋框樣式: .minimal -> SearchBar 沒有背景，且搜尋欄位為半透明
        searchController.searchBar.searchBarStyle = .minimal
        // 完成按鈕文案
        searchController.searchBar.returnKeyType = .done
        // 預設文字
        searchController.searchBar.placeholder = "搜尋"
        // 首字自動變大寫
        searchController.searchBar.autocapitalizationType = .none
        // 搜尋時是否隱藏 NavigationBar
        searchController.hidesNavigationBarDuringPresentation = false
        // 監聽搜尋事件
        searchController.searchResultsUpdater = self
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableView.rowHeight = cellHeight
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    private let emptyStateView: EmptyStateView = EmptyStateView()

    // MARK: Setup

    private func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.backgroundColor = .appColor(.background1)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        setupLayout()
    }

    private func setupLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyStateView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
    }

    private func bindViewModel() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .success:
                    self.updateUI()
                case .failed(let error):
                    self.handleError(error)
                case .loading, .none:
                    return
                }
            }.store(in: &cancellables)
    }

    private func updateUI() {
        if viewModel.totalCount == 0 {
            viewModel.searchTerm.isEmpty ? showPlaceholder() : showNoResults()
        } else {
            showResults()
        }
    }

    private func handleError(_ error: Error) {
        print(error)
        showNoResults()
    }

    private func showPlaceholder() {
        emptyStateView.configure(title: "想找哪首歌？", message: "請輸入歌名搜尋。")
        emptyStateView.isHidden = false
        tableView.isHidden = true
    }

    private func showResults() {
        emptyStateView.isHidden = true
        tableView.reloadData()
        tableView.isHidden = false
    }

    private func showNoResults() {
        emptyStateView.configure(title: "沒有結果", message: "嘗試新的搜尋項目。")
        emptyStateView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension NetworkSampleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier) as? TrackCell
        else {
            return UITableViewCell()
        }

        guard let track = viewModel.track(forCellAt: indexPath.row) else {
            return cell
        }

        cell.configure(artworkUrl: track.artworkUrl100, collectionName: track.collectionName, artistName: track.artistName, trackName: track.trackName, showsHighlight: true)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        cellHeight
    }
}

// MARK: - UISearchResultsUpdating

extension NetworkSampleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchTerm = searchController.searchBar.text ?? ""
    }
}
