//
//  APIRequest.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/17.
//

import Foundation

protocol APIRequest {
    // 讓每個API請求定義自己的特定回應類型
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: ContentType { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }

    var contentType: ContentType {
        return .json
    }

    var body: Data? {
        return nil
    }

    func buildRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")

        if let parameters {
            switch method {
            case .get:
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
                request.url = urlComponents?.url
            default:
                break
            }
        }

        return request
    }
}
