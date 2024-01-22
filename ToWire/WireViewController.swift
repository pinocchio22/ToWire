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

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

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

    private let resultLabel: CustomLabel = {
        let label = CustomLabel(text: "수취금액", font: Typography.largeContent.font, alignment: .center)
        return label
    }()

    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.center = self.view.center
        indicator.color = .black
        return indicator
    }()

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
        view.addSubview(indicator)

        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            // wireTableView
            wireTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constanst.defaults.vertical),
            wireTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constanst.defaults.horizontal),
            wireTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constanst.defaults.horizontal),
            wireTableView.heightAnchor.constraint(equalToConstant: Constanst.screenHeight * 0.3),

            // resultLabel
            resultLabel.topAnchor.constraint(equalTo: wireTableView.bottomAnchor, constant: Constanst.defaults.vertical),
            resultLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}

private extension WireViewController {
    // MARK: Bind

    func bind() {
        wireViewModel.selectedItem.bind { [weak self] selectedItem in
            if let selectedItem = selectedItem {
                self?.updateUI(selectedItem: selectedItem)
                self?.updateReultLabel()
            }
        }


        wireViewModel.wirePrice.bind { [weak self] _ in
            self?.updateReultLabel()
        }
    }
}

private extension WireViewController {
    // MARK: Method

    func getUIList() {
        uiModelList = wireViewModel.getUIData()
        wireTableView.reloadData()
    }

    func updateUI(selectedItem: ExchangeRateModel) {
        DispatchQueue.main.async {
            let section = 0
            print(TableCellIndex.send.rawValue)
            if let pickerCell = self.wireTableView.cellForRow(at: IndexPath(row: TableCellIndex.send.rawValue, section: section)) as? PickerTableViewCell {
                pickerCell.updateUI(updatePickerItem: selectedItem.type.rawValue)
            }

            if let firstTextCell = self.wireTableView.cellForRow(at: IndexPath(row: TableCellIndex.recieve.rawValue, section: section)) as? TextTableViewCell,
               let secondTextCell = self.wireTableView.cellForRow(at: IndexPath(row: TableCellIndex.exchange.rawValue, section: section)) as? TextTableViewCell
            {
                firstTextCell.updateUI(updateDescription: "\(selectedItem.price.toString()) \(selectedItem.type.rateDscription)")
                secondTextCell.updateUI(updateDescription: selectedItem.timeStamp.toDate())
            }
        }
    }

    func updateReultLabel() {
        print(wireViewModel.getResultPrice())
        resultLabel.text = wireViewModel.getResultPrice()
        if let text = resultLabel.text {
            resultLabel.textColor = wireViewModel.isDigits(text: text) ? .red : .black
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
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            textCell.bind(title: item.title, descripTion: item.description)
            return textCell
        case .picker:
            guard let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier, for: indexPath) as? PickerTableViewCell else { return UITableViewCell() }
            pickerCell.delegate = self
            pickerCell.bind(title: item.title, pickerItem: wireViewModel.selectedItem.value?.type.rawValue ?? "")
            return pickerCell
        case .input:
            guard let inputCell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.identifier, for: indexPath) as? InputTableViewCell else { return UITableViewCell() }
            inputCell.delegate = self
            inputCell.bind(title: item.title, inputPrice: "")
            return inputCell
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
        wireViewModel.getPriceData(currencyType: CurrencyType.allCases[row]) { data in
            DispatchQueue.main.async {
                self.indicator.startAnimating()
            }

            if data != nil {
                self.wireViewModel.selectedItem.value = data
            }

            DispatchQueue.main.async {
                if self.wireViewModel.selectedItem.value == nil {
                    AlertMaker.showAlertAction(vc: self, title: "데이터를 가져오지 못했습니다.", message: "잠시후 다시 시도하세요.")
                    self.indicator.stopAnimating()
                }
                self.indicator.stopAnimating()
            }
        }
    }
}

extension WireViewController: InputTableViewCellDelegate {
    func inputTableViewCell(cell: InputTableViewCell, didChangeText: String?, textField: UITextField) {
        wireViewModel.wirePrice.value = didChangeText
    }
}

extension WireViewController: PickerTableViewCellDelegate {
    func setDelegate(pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
}
