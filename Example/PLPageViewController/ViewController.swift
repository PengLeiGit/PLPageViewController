//
//  ViewController.swift
//  PLPageViewController
//
//  Created by PengLei on 11/19/2019.
//  Copyright (c) 2019 PengLei. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var listTableView: UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "DemoCell")
        return tableview
    }()
    
    lazy var dataArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        baseSetting()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI
extension ViewController {
    func initUI() {
        view.addSubview(listTableView)
        listTableView.snp.remakeConstraints { (make) ->Void in
            make.edges.equalTo(view)
        }
    }
    
    func baseSetting() {
        title = "Demo"
        dataArray = [
        "基本使用 - 简单示例",
        "基本使用 - 分类栏属性设置",
        "基本使用 - 分割线的设置",
        "基本使用 - 设置分类栏的左右控件",
        "基本使用 - 分类栏在导航栏上",
        "基本使用 - 指示器的设置"
        ]
        /*
        "高级使用 - 滑动悬停分类栏（无导航栏）",
        "高级使用 - 滑动悬停分类栏（有导航栏）",
        "高级使用 - 多级页面",
        "未读标记 - 配置"
         */
    }
}

// MARK: - 代理
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = PLOneViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = PLTwoViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = PLThreeViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PLFourViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = PLFiveViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = PLSixViewController()
            navigationController?.pushViewController(vc, animated: true)
//        case 6:
//            let vc = PLSlidingSuspensionVC()
//            navigationController?.pushViewController(vc, animated: true)
//        case 7:
//            let vc = MCSlidingSuspensionTwoViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        case 8:
//            let vc = MCThreeLevelViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        case 9:
//            let vc = MCBadgeOneViewController()
//            navigationController?.pushViewController(vc, animated: true)
//
        default:
            break
        }
    }
}

