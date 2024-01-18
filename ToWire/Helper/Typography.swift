//
//  Typography.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

enum Typography {
    case title
    case smallContent
    case largeContent
    
    var font: UIFont {
        switch self {
        case .title:
            return .systemFont(ofSize: 40, weight: .bold)
        case .smallContent:
            return .systemFont(ofSize: 16, weight: .light)
        case .largeContent:
            return .systemFont(ofSize: 20, weight: .medium)
        }
    }
}
