//
//  NetworkManager.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

class NetworkManager {
    func fetchData(completion: @escaping ([ExchangeRateModel]?) -> Void) {
        let session = URLSession.shared
        
        var urlComponents = URLComponents(string: "http://www.apilayer.net/api/live?")
        let myKey = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_LAYER_KEY") as? String
        let keyQuery = URLQueryItem(name: "access_key", value: myKey)
        
        urlComponents?.queryItems?.append(keyQuery)

        guard let requestURL = urlComponents?.url else {
            completion(nil)
            print("잘못된 url 입니다.")
            return
        }
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successCode = 200 ..< 300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successCode.contains(statusCode) else {
                print("\(String(describing: error))")
                return
            }
            
            if let data = data {
                do {
                    var tempList = [ExchangeRateModel]()
                    let decoder = JSONDecoder()
                    let networkModel = try decoder.decode(NetworkModel.self, from: data)
                    networkModel.quotes.forEach { item in
                        switch item.key {
                        case CurrencyType.USDKRW.description:
                            tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDKRW))
                        case CurrencyType.USDJPY.description:
                            tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDJPY))
                        case CurrencyType.USDPHP.description:
                            tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDPHP))
                        default: break
                        }
                    }
                    completion(tempList)
                } catch {
                    completion(nil)
                    print("JSON 디코딩 실패: \(error)")
                }
            } else {
                print("\(String(describing: error))")
            }
        }
        dataTask.resume()
    }
}

extension NetworkManager {
    // MARK: Dummy
    
    func fetchDummyData(completion: @escaping ([ExchangeRateModel]?) -> Void) {
        guard let path = Bundle.main.path(forResource: "Dummy", ofType: "json") else { return }
        
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data {
            var tempList = [ExchangeRateModel]()
            if let networkModel = try? decoder.decode(NetworkModel.self, from: data) {
                networkModel.quotes.forEach { item in
                    switch item.key {
                    case CurrencyType.USDKRW.description:
                        tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDKRW))
                    case CurrencyType.USDJPY.description:
                        tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDJPY))
                    case CurrencyType.USDPHP.description:
                        tempList.append(ExchangeRateModel(price: item.value, timeStamp: networkModel.timestamp, type: .USDPHP))
                    default: break
                    }
                }
                completion(tempList)
            }
        }
    }
}
