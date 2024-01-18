//
//  NetworkModel.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

struct NetworkModel: Codable {
    let success: Bool
    let terms, privacy: String
    let timestamp: Double
    let source: String
    let quotes: [String: Double]
}
