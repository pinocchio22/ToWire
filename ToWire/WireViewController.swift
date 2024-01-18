//
//  ViewController.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class WireViewController: UIViewController {
    // MARK: Properties

    let wireViewModel = WireViewModel()
    var uiModelList: [UIModel]?

    // MARK: Components

    private let titleLabel = CustomLabel(text: "환율 계산", font: Typography.title.font, alignment: .center)

    private let wireTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        tableView.register(PickerTableViewCell.self, forCellReuseIdentifier: PickerTableViewCell.identifier)
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: InputTableViewCell.identifier)
        return tableView
    }()

    private let resultLabel = CustomLabel(text: "수취금액", font: Typography.largeContent.font, alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        bind()
        getUIList()
    }
}

private extension WireViewController {
    // MARK: SetUp

    func setUp() {
        wireTableView.delegate = self
        wireTableView.dataSource = self

        setUpConstraints()
    }

    func setUpConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(wireTableView)
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            // wireTableView
            wireTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constanst.defaults.vertical),
            wireTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constanst.defaults.horizontal),
            wireTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constanst.defaults.horizontal),
            wireTableView.heightAnchor.constraint(equalToConstant: 200),

            // resultLabel
            resultLabel.topAnchor.constraint(equalTo: wireTableView.bottomAnchor, constant: Constanst.defaults.vertical),
            resultLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}

private extension WireViewController {
    // MARK: Bind

    func bind() {
        wireViewModel.selectedItem.bind { selectedItem in
            guard let selectedItem = selectedItem else { return }
            // API call
            // UI update
            self.updateUI(selectedItem: selectedItem)
        }
    }
}

private extension WireViewController {
    // MARK: Method

    func getUIList() {
        uiModelList = wireViewModel.getUIData()
        wireTableView.reloadData()
    }

    func updateUI(selectedItem: String) {
        if let pickerCell = wireTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PickerTableViewCell {
            pickerCell.updateUI(updatePickerItem: selectedItem)
        }

        if let firstTextCell = wireTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextTableViewCell,
           let secondTextCell = wireTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TextTableViewCell
        {
            firstTextCell.updateUI(updateDescription: "바뀐 환율")
            secondTextCell.updateUI(updateDescription: "바뀐 시간")
        }
    }
}

extension WireViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wireViewModel.getDataCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = uiModelList?[indexPath.row] else { return UITableViewCell() }

        switch item.type {
        case .text:
            let textCell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell
            textCell?.bind(title: item.title, descripTion: item.description)
            return textCell ?? UITableViewCell()
        case .picker:
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier, for: indexPath) as? PickerTableViewCell
            pickerCell?.setDelegate(view: self)
            pickerCell?.bind(title: item.title, pickerItem: wireViewModel.selectedItem.value ?? "")
            return pickerCell ?? UITableViewCell()
        case .input:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.identifier, for: indexPath) as? InputTableViewCell
            inputCell?.bind(title: item.title, inputPrice: "")
            return inputCell ?? UITableViewCell()
        }
    }
}

extension WireViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wireViewModel.getPickerCount()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wireViewModel.getPickerItem()[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        wireViewModel.selectedItem.value = wireViewModel.getPickerItem()[row]
    }
}
