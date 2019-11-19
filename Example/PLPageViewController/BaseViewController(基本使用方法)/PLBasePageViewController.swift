//
//  PLBasePageViewController.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PLPageViewController


class PLBasePageViewController: UIViewController {
    /// 分类条
    lazy var categoryBar: PLCategoryBar = {
        let view = PLCategoryBar()
        view.delegate = self
        return view
    }()
    
    /// 内容容器
    lazy var containerView: PLContainerView = {
        let view = PLContainerView()
        view.delegate = self
        return view
    }()
    
    var vcArray: [UIViewController] = []
    var modelArray: [PLCategoryBarModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createData()
        
    }

}

extension PLBasePageViewController {
    func createData() {
            
            for i in 0..<10 {
                
                let model = PLCategoryBarModel()
                let titleStr = "第" + String(i) + "页"
                model.title = titleStr
                
                let vc = PLBaseSubViewController()
                vc.delegate = self
                vc.pageExplain = titleStr
                vc.fatherViewController = self
                vcArray.append(vc)
                modelArray.append(model)
                self.addChild(vc)
            }
        }
}

extension PLBasePageViewController: PLCategoryBarDelegate {
    func categoryBar(categoryBar: PLCategoryBar, didSelectItemAt index: Int) {
        containerView.containerViewScrollToSubViewController(subIndex: index)
    }
}

extension PLBasePageViewController: PLContainerViewDelegate {
    
    func containerView(_ containerView: PLContainerView, didScrollToIndex index: Int) {
        categoryBar.categoryBarDidClickItem(at: index)
    }
}

extension PLBasePageViewController: JumpToOtherIndex {
    func jumpToOtherIndex(_ index: Int) {
        containerView.containerViewScrollToSubViewController(subIndex: index)
        categoryBar.categoryBarDidClickItem(at: index)
    }
}
