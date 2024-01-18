//
//  NetworkManager.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

class NetworkManager {
    func fetchData(completion: @escaping ([ExchangeRateModel]) -> Void) {
        let session = URLSession.shared
        
        var urlComponents = URLComponents(string: "http://www.apilayer.net/api/live?")
        let myKey = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_LAYER_KEY") as? String
        print("@@@ \(String(describing: myKey))")
        let keyQuery = URLQueryItem(name: "access_key", value: myKey)
        
        var priceList = [ExchangeRateModel]()
        
        urlComponents?.queryItems?.append(keyQuery)

        guard let requestURL = urlComponents?.url else {
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
                    let decoder = JSONDecoder()
                    let networkModel = try decoder.decode(NetworkModel.self, from: data)
                    networkModel.quotes.forEach { item in
                        switch item.key {
                        case CurrencyType.krw.rawValue, CurrencyType.jpy.rawValue, CurrencyType.php.rawValue:
                            priceList.append(ExchangeRateModel(country: item.key, price: item.value))
                        default: break
                        }
                    }
                } catch {
                    print("JSON 디코딩 실패: \(error)")
                }
            } else {
                print("\(String(describing: error))")
            }
            completion(priceList)
        }
        dataTask.resume()
    }
}