//
//  PLBaseSubViewController.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
protocol JumpToOtherIndex: NSObjectProtocol {
    func jumpToOtherIndex(_ index: Int)
}

class PLBaseSubViewController: UIViewController {
    
    public weak var delegate: JumpToOtherIndex?
    
    public var pageExplain = ""
    
    public var fatherViewController: UIViewController?
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .plain)
        tb.backgroundColor = UIColor.clear
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension PLBaseSubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = pageExplain + "  第" + String(indexPath.row) + "行"
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("跳转到下一页面")
    }

}

extension PLBaseSubViewController {
    func initUI() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) ->Void in
            make.edges.equalTo(view)
        }
    }
}
