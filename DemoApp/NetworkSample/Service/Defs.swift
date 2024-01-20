//
//  Defs.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/17.
//

import Foundation

// MARK: - Defs

enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case query = "QUERY"
    case trace = "TRACE"
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded; charset=utf-8"
    case multiPartFormData = "multipart/form-data"
}

enum RequestError: Error {
    case urlError
}

enum ResponseError: Error {
    case nilData
    case nonHTTPResponse
    case tokenError
    case apiError(error: APIError)
}

struct APIError: Error {
    let data: Data?
    let statusCode: Int
}
