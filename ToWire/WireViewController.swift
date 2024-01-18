//
//  ViewController.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class WireViewController: UIViewController {
    // Components
    private let titleLabel = CustomLabel(text: "환율 계산", font: Typography.title.font)
    
    private let wireTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let resultLabel = CustomLabel(text: "수취금액", font: Typography.largeContent.font)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

