//
//  CustomLabel.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class CustomLabel: UILabel {

    init(text: String, textColor: UIColor = .black, font: UIFont) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
