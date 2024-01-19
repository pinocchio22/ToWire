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
    
    let uiModelList = [
        UIModel(title: "송금국가", description: "미국(USD)", type: .text),
        UIModel(title: "수취국가", description: "", type: .picker),
        UIModel(title: "환율", description: "수취 국가를 선택하세요", type: .text),
        UIModel(title: "조회시간", description: "수취 국가를 선택하세요", type: .text),
        UIModel(title: "송금액", description: "USD", type: .input),
    ]
    
    // MARK: Method
    func getPriceData(currencyType: CurrencyType, completion: @escaping (ExchangeRateModel?) -> Void) {
//        networkManager.fetchData { data in
        networkManager.fetchDummyData { data in
            guard let data = data else {
                completion(nil)
                return
            }
            if data.type == currencyType {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    func getResultPrice() -> String {
        guard let selectedItem = selectedItem.value?.price, let wirePrice = wirePrice.value, let number = Double(wirePrice), !wirePrice.isEmpty, (0 ... 10000).contains(number) else {
            return "송금액이 바르지 않습니다."
        }
        return (selectedItem * number).toString()
    }
    
    func getUIData() -> [UIModel] {
        return uiModelList
    }
    
    func getDataCount() -> Int {
        return uiModelList.count
    }
    
    func getPickerItem() -> [String] {
        return pickerItem
    }
    
    func getPickerCount() -> Int {
        return pickerItem.count
    }
}
