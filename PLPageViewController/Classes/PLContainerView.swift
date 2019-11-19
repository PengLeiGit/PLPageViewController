//
//  PLContainerView.swift
//  PLPageViewController
//
//  Created by 彭磊 on 2019/11/19.
//

import UIKit

@objc public protocol PLContainerViewDelegate {
    
    /// 滑动到对应控制器
    func containerView(_ containerView: PLContainerView, didScrollToIndex index: Int)

    
    /// 做悬挂分类栏时候用到
    @objc optional func containerViewWillBeginDragging(_ containerView: PLContainerView)
    @objc optional func containerViewWilldidEndDragging(_ containerView: PLContainerView)
    
}

public class PLContainerView: UIView {
    
    /// 做悬挂分类栏时候用到
    public var currentChildPageViewController: PLPageChildViewController?
    
    public weak var delegate: PLContainerViewDelegate?
    
    
    
    /**
     * 根据数据直接创建
     */
    public func initContainerViewWithConfig(_ config: PLPageConfig) {
        
        /// 检查配置
        if !isConfiguratioCorrect(config: config) {
            return
        }
        
        let index = config.defaultIndex
        
        self.config = config
        
        
        // 指定当前的子控制器
        currentChildPageViewController = config.viewControllers[index] as? PLPageChildViewController
        
        /// 指定当前选中的viewController
        containerViewScrollToSubViewController(subIndex: index)
    }
    
    private var selectedIndex = 0
    private var config: PLPageConfig = PLPageConfig()
    

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initBaseUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        /// 重置
        self.config.empty()
        self.selectedIndex = 0
    }
    
    
    // MARK: - Setter & Getter
    
    private lazy var pageVC: UIPageViewController = {
        let vc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        vc.view.backgroundColor = UIColor.white
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
}




//MARK: UI的处理,通知的接收
private extension PLContainerView {
    
    
    // 基础UI的设置
    private func initBaseUI() {
 
        self.addSubview(pageVC.view)
        pageVC.view.snp.remakeConstraints { (make) ->Void in
            make.left.right.bottom.top.equalTo(self)
        }
    }
    
    /// 检查配置
    private func isConfiguratioCorrect(config: PLPageConfig) -> Bool {
        if (config.categoryModels.count != config.viewControllers.count) ||
            config.categoryModels.count == 0 ||
            config.viewControllers.count == 0 {
            print("MCPageViewController:\n 请检查config的配置 config.vcs.count:\(config.categoryModels.count) --- config.vcs.count:\(config.viewControllers.count)")
            return false
        }
        
        if config.defaultIndex < 0 || config.defaultIndex >= config.viewControllers.count {
            print("MCPageViewController:\n 请检查config的配置config.defaultIndex")
            return false
        }
        return true
    }
}


extension PLContainerView : UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let viewControllers = config.viewControllers
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        if index == viewControllers.count - 1 {
            return nil
        }
        return viewControllers[index + 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let viewControllers = config.viewControllers
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        if index == 0 {
            return nil
        }
        if let index = viewControllers.firstIndex(of: viewController) {
            return viewControllers[index - 1]
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let sub = pageViewController.viewControllers![0]
        var index = 0
        for subVc in config.viewControllers {
            if subVc.isEqual(sub) {
                selectedIndex = index
                break
            }
            index += 1
        }
        /// 滑动了pageViewController，选中对应的分类tab
        currentChildPageViewController = config.viewControllers[selectedIndex] as? PLPageChildViewController
        delegate?.containerView(self, didScrollToIndex: selectedIndex)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.containerViewWillBeginDragging?(self)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.containerViewWilldidEndDragging?(self)
    }
    
}

extension PLContainerView {
    
    /// 更改选中的页面
    public func containerViewScrollToSubViewController(subIndex index: Int)  {
        if config.viewControllers.count <= index {
            return
        }
        let toPage = index
        let direction : UIPageViewController.NavigationDirection = selectedIndex > toPage ? .forward : .reverse
        pageVC.setViewControllers([config.viewControllers[toPage]], direction: direction, animated: false) { [weak self] (finished) in
            self?.selectedIndex = toPage;
            
            self?.currentChildPageViewController = self?.config.viewControllers[toPage] as? PLPageChildViewController
        }
    }
}
