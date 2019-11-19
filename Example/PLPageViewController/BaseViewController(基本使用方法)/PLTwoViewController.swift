//
//  PLTwoViewController.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PLPageViewController
class PLTwoViewController: PLBasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageViewController()
        initUI()
    }
    
    func initUI() {
        navigationItem.title = "分类栏属性设置"
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
        // 分类名字最长显示字数
        config.category.maxTitleCount = 6
        config.category.normalColor = UIColor.gray
        config.category.selectedColor = UIColor.red
        config.category.normalFont = UIFont.systemFont(ofSize: 14)
        config.category.selectFont = UIFont.systemFont(ofSize: 16)
        // 设置为0，系统会自动计算item的宽度。大于0，则系统默认使用该宽度。
        config.category.itemWidth = 60
        // item的额外添加宽度。itemWidth为0时有效。 此时itemWidth = 文字动态计算的宽度 + itemExtendWidth
        config.category.itemExtendWidth = 0
        // 整个分类栏的背景颜色
        config.category.barBackgroundColor = UIColor.white
        // item的背景颜色
        config.category.itemBackgroundColor = UIColor.orange
        // item的间距
        config.category.itemSpacing = 10
        
        config.category.maxTitleCount = 4
        config.category.itemSpacing = 5
        
        config.itemSeparator.backgroundColor = UIColor.red
        config.itemSeparator.width = 2
        config.itemSeparator.height = 30
        config.itemSeparator.isHidden = false
        config.itemSeparator.cornerRadius = 1
        
        categoryBar.initCategoryBarWithConfig(config)
        containerView.initContainerViewWithConfig(config)
    }
}
