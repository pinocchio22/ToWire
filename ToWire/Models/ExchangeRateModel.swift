//
//  PriceModel.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

struct ExchangeRateModel: Codable {
    let country: String
    let price: Double
    let timeStamp: Date
    let type: CurrencyType
}
