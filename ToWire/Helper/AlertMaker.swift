//
//  AlertMaker.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/19.
//

import UIKit

enum AlertMaker {
    static func showAlertAction(vc: UIViewController?, preferredStyle: UIAlertController.Style = .alert, title: String? = "", message: String? = "", completeTitle: String = "확인") {
        guard let currentVc = vc else {
            return
        }
                
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            let completeAction = UIAlertAction(title: completeTitle, style: .default)
                    
            alert.addAction(completeAction)
                    
            if let alertController = currentVc.presentedViewController as? UIAlertController {
                alertController.dismiss(animated: true) {
                    currentVc.present(alert, animated: true, completion: nil)
                }
            } else {
                currentVc.present(alert, animated: true, completion: nil)
            }
        }
    }
}
