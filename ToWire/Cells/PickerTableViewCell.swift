//
//  PickerTableViewCell.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

protocol PickerTableViewCellDelegate: AnyObject {
    func setDelegate(pickerView: UIPickerView)
    func selectedRowInPickerView() -> Int
}

class PickerTableViewCell: UITableViewCell {
    // MARK: Properties

    weak var delegate: PickerTableViewCellDelegate?
    
    private var selectedRowIndex = 0
    
    // MARK: Components

    private let titleLabel = CustomLabel(text: "text", font: Typography.smallContent.font, alignment: .right)
    
    private let separatorLabel = CustomLabel(text: ":", font: Typography.smallContent.font, alignment: .center)
    
    lazy var pickerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.borderStyle = .none
        textField.placeholder = "수취국가를 선택하세요."
        textField.inputView = self.pickerView
        return textField
    }()
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
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
        delegate?.setDelegate(pickerView: pickerView)
        selectedRowIndex = delegate?.selectedRowInPickerView() ?? 0
        pickerView.selectRow(selectedRowIndex, inComponent: 0, animated: true)
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
}
