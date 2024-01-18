//
//  ViewController.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import UIKit

class WireViewController: UIViewController {
    // MARK: Components
    private let titleLabel = CustomLabel(text: "환율 계산", font: Typography.title.font)
    
    private let wireTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let resultLabel = CustomLabel(text: "수취금액", font: Typography.largeContent.font)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        
        let n = NetworkManager()
        n.fetchData() { item in
            print(item)
        }
    }
}

private extension WireViewController {
    // MARK: SetUp
    func setUp() {
//        wireTableView.delegate = self
//        wireTableView.dataSource = self
    }
}

//extension WireViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
