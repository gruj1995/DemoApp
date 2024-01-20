//
//  SearchRequest.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/16.
//

import Foundation

/// 搜尋

// MARK: - SearchRequest

struct SearchRequest: APIRequest {

    // MARK: Lifecycle

    init(term: String, limit: Int, offset: Int) {
        self.term = term
        self.limit = limit
        self.offset = offset
    }

    // MARK: Internal

    typealias Response = [[String]]

    let path: String = "/search"

    let method: HTTPMethod = .get

    let contentType: ContentType = .json

    var headers: [String: String]?

    var parameters: [String: Any]? {
        return [
            "term": term,
            "media": media,
            "limit": "\(limit)",
            "offset": "\(offset)",
            "country": country,
            "lang": language
        ]
    }

    // MARK: Private

    /// 要搜索的 URL 編碼文本字符串
    /// (目前測試 itunes api 有處理中文和空格轉加號，所以這邊不用特別加處理機制)
    private let term: String

    /// 媒體種類(強制設為音樂)
    private let media: String = "music"

    /// 單次搜尋筆數上限
    private let limit: Int

    /// 偏移量(搜尋結果分頁機制相關)
    private let offset: Int

    /// 國家代碼
    private var country: String {
        Utils.countryCode
    }

    /// 語言代碼
    private var language: String {
        Utils.languageId
    }
}
