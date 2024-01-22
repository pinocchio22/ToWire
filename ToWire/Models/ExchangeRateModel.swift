//
//  PriceModel.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

struct ExchangeRateModel: Codable {
    var price: Double
    var timeStamp: Double
    var type: CurrencyType
}
