//
//  TextTableViewCell.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    // MARK: Components

    private let titleLabel = CustomLabel(text: "text", font: Typography.smallContent.font, alignment: .right)
    
    private let separatorLabel = CustomLabel(text: ":", font: Typography.smallContent.font, alignment: .center)
    
    private let descriptionLabel = CustomLabel(text: "description", font: Typography.smallContent.font, alignment: .left)
    
    // MARK: LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Bind

    func bind(title: String, descripTion: String) {
        titleLabel.text = title
        descriptionLabel.text = descripTion
    }
}

private extension TextTableViewCell {
    // MARK: SetUp
    
    func setUp() {
        self.contentView.isUserInteractionEnabled = false
        self.selectionStyle = .none
        setUpConstraints()
    }
}

private extension TextTableViewCell {
    // MARK: Methods
    
    func setUpConstraints() {
        addSubview(titleLabel)
        addSubview(separatorLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constanst.defaults.vertical),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
                    
            // separatorLabel
            separatorLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constanst.defaults.vertical),
            separatorLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            separatorLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            separatorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
                    
            // descriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constanst.defaults.vertical),
            descriptionLabel.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        ])
    }
}
