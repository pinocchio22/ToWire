//
//  Constants.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

struct Constanst {
    static let defaults = Default()
    
    struct Default {
        let vertical: CGFloat = 12
        let horizontal: CGFloat = 16
        let cornerRadius: CGFloat = 8
    }
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}
