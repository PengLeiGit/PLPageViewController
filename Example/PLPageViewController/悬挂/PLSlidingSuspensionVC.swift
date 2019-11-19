//
//  PLSlidingSuspensionVC.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PLPageViewController

class PLSlidingSuspensionVC: PLPageChildViewController {
    public var pageExplain = ""
    public var fatherViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initUI()
    }
    
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return tb
    }()
}

extension PLSlidingSuspensionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /// 如果分类栏置顶之后向下滑动，点击headerView使之停止滑动，第一下点击不触发didSelectRowAt方法，可以再cell底部添加一个button。原因是响应者链条的原因。具体未知。
//        let button = UIButton.init(type: .custom)
//        button.addTarget(self, action: #selector(buttenEvent), for: .touchUpInside)
//
//        cell.contentView.addSubview(button)
//        button.snp.remakeConstraints { (make) ->Void in
//            make.edges.equalTo(cell.contentView)
//        }
        
        cell.textLabel?.text = pageExplain + "  第" + String(indexPath.row) + "行"
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了")
    }
    
    @objc func buttenEvent() {
          print("点击了 buttenEvent")
    }
    
}


extension PLSlidingSuspensionVC {
    func initUI() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) ->Void in
            make.edges.equalTo(view)
        }
    }
}
