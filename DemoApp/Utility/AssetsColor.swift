//
//  AssetsColor.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/20.
//

import UIKit

// MARK: - AssetsColor

enum AssetsColor: String {
    case background1
    case text1
    case lightGray
    case separator
    case gray1
    case gray2
    case gray3
    case gray4
    case white1
    case white2
    case black1
    case blue
    case purple
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        UIColor(named: name.rawValue)
    }
}
