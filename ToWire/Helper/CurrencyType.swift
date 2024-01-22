//
//  CurrencyType.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

enum CurrencyType: String, CaseIterable, Codable {
    case USDKRW = "한국(KRW)"
    case USDJPY = "일본(JPY)"
    case USDPHP = "필리핀(PHP)"

    var description: String {
        return String(describing: self)
    }

    var rateDscription: String {
        switch self {
        case .USDKRW:
            return "USD / KRW"
        case .USDJPY:
            return "USD / JPY"
        case .USDPHP:
            return "USD / PHP"
        }
    }
}
