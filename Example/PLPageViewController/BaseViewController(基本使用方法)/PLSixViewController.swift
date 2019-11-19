//
//  PLSixViewController.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PLPageViewController
class PLSixViewController: PLBasePageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPageViewController()
        
        initUI()
    }
    
    
    func initUI() {
        
        navigationItem.title = "指示器的设置"
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
    }
    
    func loadPageViewController() {
        
        let config = PLPageConfig()
        
        config.viewControllers = vcArray
        config.categoryModels = modelArray
        
        config.indicator.isHidden = false
        config.indicator.backgroundColor = UIColor.red
        config.indicator.height = 4
        config.indicator.cornerRadius = 2
        categoryBar.initCategoryBarWithConfig(config)
        containerView.initContainerViewWithConfig(config)
    }
}
