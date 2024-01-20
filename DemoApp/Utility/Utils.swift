//
//  Utils.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/17.
//

import Foundation

struct Utils {
    /// 參考：https://blog.csdn.net/weixin_33717298/article/details/88703905
    static let iso8601DateFormatter = ISO8601DateFormatter()

    static var currentLocale: Locale {
        return Locale.current
    }

    static var countryCode: String {
        if #available(iOS 16, *) {
            return currentLocale.language.region?.identifier ?? ""
        } else {
            return currentLocale.regionCode ?? ""
        }
    }

    static var languageId: String {
        if #available(iOS 16, *) {
            return currentLocale.language.languageCode?.identifier ?? ""
        } else {
            return currentLocale.languageCode ?? ""
        }
    }
}
