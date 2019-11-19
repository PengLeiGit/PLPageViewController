//
//  PLFourViewController.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PLPageViewController

class PLFourViewController: PLBasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        loadPageViewController()
        
        initUI()
    }
    
    lazy var showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("更多", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(event), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        return btn
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("搜索", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(event), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        return btn
    }()

    
    func initUI() {
        navigationItem.title = "分类栏设置左右控件"
        view.backgroundColor = UIColor.white
        
        view.addSubview(categoryBar)
        categoryBar.snp.remakeConstraints { (make) ->Void in
            make.left.right.equalTo(view)
            make.top.equalTo(UIDevice.navigationBarHeight)
            make.height.equalTo(40)
        }
        
        
        view.addSubview(containerView)
        containerView.snp.remakeConstraints { (make) ->Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(categoryBar.snp.bottom)
        }
        
        categoryBar.addSubview(showButton)
        showButton.snp.remakeConstraints { (make) ->Void in
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(50)
        }
        
        
        categoryBar.addSubview(searchButton)
        searchButton.snp.remakeConstraints { (make) ->Void in
            make.top.bottom.left.equalTo(0)
            make.width.equalTo(50)
        }
    }
    
    func loadPageViewController() {
        
        let config = PLPageConfig()
        
        config.viewControllers = vcArray
        config.categoryModels = modelArray
        config.defaultIndex = 0
        
        config.category.inset = (50, 50)
        
        categoryBar.initCategoryBarWithConfig(config)
        containerView.initContainerViewWithConfig(config)
    }
}


extension PLFourViewController {
    
    @objc func event() {
        print("点击了")
    }
}
