//
//  AlertMaker.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/19.
//

import UIKit

class AlertMaker {
    static func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String? = "", message: String? = "", completeTitle: String = "확인", _ completeHandler: (() -> Void)? = nil) {
        guard let currentVc = vc else {
            completeHandler?()
            return
        }
            
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
                
            let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
                completeHandler?()
            }
                
            alert.addAction(completeAction)
                
            currentVc.present(alert, animated: true, completion: nil)
        }
    }
}
