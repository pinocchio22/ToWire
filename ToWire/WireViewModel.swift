//
//  WireViewModel.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

class WireViewModel {
    // MARK: Properties

    private let networkManager = NetworkManager()
    
    private let pickerItem = CurrencyType.allCases.map { $0.rawValue }
    
    var selectedItem: Observable<ExchangeRateModel> = Observable(nil)
    
    var wirePrice: Observable<String> = Observable("")
    
    var uiModelList: Observable<[UIModel]> = Observable(TableCellIndex.allCases.map { UIModel(title: $0.title, description: $0.description, type: $0.type) })
    
    // MARK: Method

    func getPriceData(currencyType: CurrencyType, completion: @escaping (ExchangeRateModel?) -> Void) {
//        networkManager.fetchData { data in
        networkManager.fetchDummyData { data in
            guard let data = data else {
                completion(nil)
                return
            }
            if data.type == currencyType {
                self.selectedItem.value = data
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateUiModel() {
        if let type = selectedItem.value?.type, let price = selectedItem.value?.price, let time = selectedItem.value?.timeStamp {
            uiModelList.value?[TableCellIndex.recieve.rawValue - 1].description = type.description
            uiModelList.value?[TableCellIndex.exchange.rawValue - 1].description = String(price)
            uiModelList.value?[TableCellIndex.time.rawValue - 1].description = time.toDate()
        }
    }
    
    func getResultPrice() -> String {
        guard let selectedItem = selectedItem.value, let wirePrice = wirePrice.value, let number = Double(wirePrice), !wirePrice.isEmpty, (0 ... 10000).contains(number) else {
            return "송금액이 바르지 않습니다."
        }
        return "수취금액은 \((selectedItem.price * number).toString()) \(selectedItem.type.description.suffix(3)) 입니다."
    }
    
    func isDigits(text: String) -> Bool {
        let isAllLetters = text.unicodeScalars.allSatisfy { !CharacterSet.decimalDigits.contains($0) }
        return isAllLetters
    }
    
    func getUIData(completion: @escaping () -> Void) -> [UIModel] {
        guard let model = uiModelList.value else { return [] }
        completion()
        return model
    }
    
    func getDataCount() -> Int {
        guard let count = uiModelList.value?.count else { return 0 }
        return count
    }
    
    func getPickerItem() -> [String] {
        return pickerItem
    }
    
    func getPickerCount() -> Int {
        return pickerItem.count
    }
}

enum TableCellIndex: Int, CaseIterable {
    case send = 1
    case recieve = 2
    case exchange = 3
    case time = 4
    case price = 5
    
    var title: String {
        switch self {
        case .send:
            return "송금국가"
        case .recieve:
            return "수취국가"
        case .exchange:
            return "환율"
        case .time:
            return "조회시간"
        case .price:
            return "송금액"
        }
    }
    
    var description: String {
        switch self {
        case .send:
            return "미국(USD)"
        case .recieve, .exchange, .time:
            return "송금국가를 입력해주세요."
        case .price:
            return "USD"
        }
    }
    
    var type: CellType {
        switch self {
        case .send, .exchange, .time:
            return .text
        case .recieve:
            return .picker
        case .price:
            return .input
        }
    }
}
