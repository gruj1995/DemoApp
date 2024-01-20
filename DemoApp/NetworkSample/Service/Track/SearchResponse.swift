//
//  SearchResponse.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/20.
//

import Foundation

// MARK: - SearchResponse

struct SearchResponse: Codable {
    // MARK: Internal

    let results: [TrackData]

    let resultCount: Int

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case results, resultCount
    }
}

// MARK: - TrackData

struct TrackData: Codable, CustomStringConvertible {
    // MARK: Internal

    /// 專輯封面圖示 (取得尺寸為100x100的圖片)
    let artworkUrl100: String

    /// 專輯名稱
    let collectionName: String

    /// 歌手
    let artistName: String

    /// 歌曲id
    let trackId: Int

    /// 歌曲名稱
    let trackName: String

    /// 在iTunes上發行的日期(格式 ISO 8601: 2016-07-21T07:00:00Z)
    let releaseDate: String

    /// 歌手預覽網址
    let artistViewUrl: String

    /// 專輯預覽網址
    let collectionViewUrl: String

    /// 單曲預覽網址
    let previewUrl: String

    /// 單曲網址
    let trackViewUrl: String

    var description: String {
        return "artworkUrl: \(artworkUrl100)\n" +
            "collectionName: \(collectionName)\n" +
            "artistName: \(artistName)\n" +
            "trackId: \(trackId)\n" +
            "trackName: \(trackName)\n" +
            "releaseDate: \(releaseDate)\n" +
            "artistViewUrl: \(artistViewUrl)\n" +
            "collectionViewUrl: \(collectionViewUrl)\n" +
            "previewUrl: \(previewUrl)\n" +
            "trackViewUrl: \(trackViewUrl)\n"
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case artworkUrl100, collectionName, artistName, trackId, trackName, releaseDate, artistViewUrl, collectionViewUrl, previewUrl, trackViewUrl
    }
}

extension TrackData {
    func convertToTrack() -> Track {
        Track(artworkUrl100: artworkUrl100, collectionName: collectionName, artistName: artistName, trackId: trackId, trackName: trackName, releaseDate: releaseDate, artistViewUrl: artistViewUrl, collectionViewUrl: collectionViewUrl, previewUrl: previewUrl, trackViewUrl: trackViewUrl)
    }
}
