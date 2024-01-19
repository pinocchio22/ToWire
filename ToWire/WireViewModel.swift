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
    
    var selectedItem: Observable<ExchangeRateModel> = Observable(ExchangeRateModel(country: "국가 정보 없음", price: 3.0, timeStamp: 0.0, type: CurrencyType.USDKRW))
    
    let uiModelList = [
        UIModel(title: "송금국가", description: "미국(USD)", type: .text),
        UIModel(title: "수취국가", description: "한국(KRW)", type: .picker),
        UIModel(title: "환율", description: "환율 조회중", type: .text),
        UIModel(title: "조회시간", description: "환율 조회중", type: .text),
        UIModel(title: "송금액", description: "USD", type: .input),
    ]
    
    // MARK: Method
    func getPriceData(currencyType: CurrencyType, completion: @escaping (ExchangeRateModel?) -> Void) {
        networkManager.fetchData { data in
            if data.type == currencyType {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    func getResultPrice(text: String?) -> String {
        guard let selectedItem = selectedItem.value?.price, let text = text, let number = Double(text), !text.isEmpty, (0 ... 10000).contains(number) else {
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
