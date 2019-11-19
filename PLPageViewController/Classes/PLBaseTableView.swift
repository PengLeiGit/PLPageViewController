//
//  PLBaseTableView.swift
//  PLPageViewController
//
//  Created by 彭磊 on 2019/11/19.
//

import UIKit

open class PLBaseTableView: UITableView, UIGestureRecognizerDelegate {
    
    public var barHeight: CGFloat = 0
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        let currentPoint: CGPoint = gestureRecognizer.location(in: self)
        
        
        let height = (self.tableFooterView?.frame.size.height ?? 0) - barHeight
        
        let segmentViewContentScrollViewHeight: CGFloat = height > 0 ? height : barHeight
        
        let contentRect = CGRect.init(x: 0, y: self.contentSize.height - segmentViewContentScrollViewHeight, width: UIDevice.width, height: segmentViewContentScrollViewHeight)
        
        if contentRect.contains(currentPoint) {
            return true
        }
        return false
    }
}



extension UIDevice {
    
    
    ///屏幕宽
    fileprivate static let width: CGFloat    = UIScreen.main.bounds.size.width
    
    ///屏幕高
    fileprivate static let height: CGFloat   = UIScreen.main.bounds.size.height
    
}
