//
//  PLPageChildViewController.swift
//  PLPageViewController
//
//  Created by 彭磊 on 2019/11/19.
//

import UIKit
public protocol PLPageChildViewControllerDelegate: NSObjectProtocol {
    func pageChildViewControllerLeaveTop(_ childViewController: PLPageChildViewController)
}

open class PLPageChildViewController: UIViewController {
    
    public weak var delegate: PLPageChildViewControllerDelegate?
    
    
    public var pageIndex: Int = 0
    
    
    private var canScroll: Bool = false
    
    private lazy var scrollView = UIScrollView()
    
    
    public func makePageViewControllerScroll(canScroll: Bool) {
        
        self.canScroll = canScroll;
        self.scrollView.showsVerticalScrollIndicator = canScroll;
        if (!canScroll) {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }
    
    public func makePageViewControllerScrollToTop() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    /// 子类重写该方法可以监听scrollViewDidScroll方法
    open func pageChildViewControllerScrollViewScroll(_ scrollView: UIScrollView) {
        
    }
    
}

extension PLPageChildViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.scrollView = scrollView
        
        pageChildViewControllerScrollViewScroll(scrollView)
        
        
        if (self.canScroll) {
            let offsetY = scrollView.contentOffset.y
            if (offsetY <= 0) {
                makePageViewControllerScroll(canScroll: false)
                delegate?.pageChildViewControllerLeaveTop(self)
            }
        } else {
            makePageViewControllerScroll(canScroll: false)
        }
    }
}

