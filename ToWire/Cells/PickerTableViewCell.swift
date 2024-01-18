//
//  PickerTableViewCell.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    // MARK: Components

    private let titleLabel = CustomLabel(text: "text", font: Typography.smallContent.font, alignment: .right)
    
    private let separatorLabel = CustomLabel(text: ":", font: Typography.smallContent.font, alignment: .center)
    
    lazy var pickerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.borderStyle = .none
        textField.inputView = self.pickerView
        return textField
    }()
    
    private let pickerView = UIPickerView()
    
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

    func bind(title: String, pickerItem: String) {
        titleLabel.text = title
        pickerTextField.text = pickerItem
    }
}

private extension PickerTableViewCell {
    // MARK: SetUp
    
    func setUp() {
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        setUpConstraints()
    }
    
    func setUpConstraints() {
        addSubview(titleLabel)
        addSubview(separatorLabel)
        addSubview(pickerTextField)
        
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
            pickerTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constanst.defaults.vertical),
            pickerTextField.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor),
            pickerTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            pickerTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pickerTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        ])
    }
}

extension PickerTableViewCell {
    // MARK: Methods
    
    func updateUI(updatePickerItem: String) {
        pickerTextField.text = updatePickerItem
    }
    
    func setDelegate(view: UIViewController & UIPickerViewDelegate & UIPickerViewDataSource) {
        pickerView.delegate = view
        pickerView.dataSource = view
    }
}
