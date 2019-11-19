//
//  PLCategoryBar.swift
//  PLPageViewController
//
//  Created by 彭磊 on 2019/11/19.
//

import UIKit

public protocol PLCategoryBarDelegate: NSObjectProtocol {
    /// 点击了分类按钮
    func categoryBar(categoryBar: PLCategoryBar, didSelectItemAt index: Int)
}

public class PLCategoryBar: UIView {
    
    private var selectedIndex = 0
    private var config: PLPageConfig = PLPageConfig()
    private var categoryModels: [PLCategoryBarModel] = []
    
    public weak var delegate: PLCategoryBarDelegate?
    
    public func initCategoryBarWithConfig(_ config: PLPageConfig) {
        
        /// 检查配置
        if !isConfiguratioCorrect(config: config) {
            return
        }

        self.config = config
        refreshUIItemSetting()
        /// 当前选中的下标
        selectedIndex = config.defaultIndex
        /// 变为选中状态
        categoryBarDidClickItem(at: selectedIndex)
    }

    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - config.separator.height)
        
        lineView.frame = CGRect.init(x: 0, y: self.bounds.size.height - config.separator.height, width: self.bounds.size.width, height: config.separator.height)
        
        indicatorView.center.y = self.bounds.size.height - config.indicator.height / 2
    }
    
    deinit {
        config = PLPageConfig()
        selectedIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(PLCategoryBarCell.classForCoder(), forCellWithReuseIdentifier: "MCCategoryCell")
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.PLPage_line
        return view
    }()
    
    private lazy var indicatorView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}



extension PLCategoryBar {
    
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
    
    
    func refreshUIItemSetting() {
        
        /// 对指示器的设置
        let indicator = config.indicator
        indicatorView.isHidden = indicator.isHidden
        indicatorView.layer.cornerRadius = indicator.cornerRadius
        indicatorView.layer.masksToBounds = true
        indicatorView.backgroundColor = indicator.backgroundColor
        indicatorView.image = indicator.image
        /// 分割线
        lineView.isHidden = config.separator.isHidden
        lineView.backgroundColor = config.separator.backgroundColor

        flowLayout.minimumInteritemSpacing = config.category.itemSpacing
        flowLayout.minimumLineSpacing = config.category.itemSpacing

        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: config.category.inset.left, bottom: 0, right: config.category.inset.right)
        collectionView.backgroundColor = config.category.barBackgroundColor
    }
    
    func initUI() {

        self.addSubview(collectionView)
        self.addSubview(lineView)
        collectionView.addSubview(indicatorView)
    }
}


//MARK: - 选中状态的处理
extension PLCategoryBar {
    /// 更改选中的分类
    public func categoryBarDidClickItem(at itemIndex: Int) {
        
        if config.categoryModels.count <= itemIndex {
            return
        }
        refreshSelectedStatus(selectedIndex: itemIndex)
        reloadCollectionView()
        layoutAndScrollToSelectedItem(itemIndex)
    }

    /// 更改选中数据 和 指示器的位置
    func refreshSelectedStatus(selectedIndex: Int) {
        
        // 获取当前选中的item的center.x的大小。
        // 当前选中的分类的X轴上的中心点 = 左边距 + 前面分类的宽度总合 + 间隔的总合 + 当前分类的宽度的一半
        // center.x = inset.left + index * (itemWidth + specing) + selectedItemWith / 2
        var selectedItemCenterX: CGFloat = config.category.inset.left
        var selectedtitleWidth: CGFloat = 0
        
        categoryModels.removeAll()
        
        let temp = config
        
        
        for (index, value) in temp.categoryModels.enumerated() {
            let model = value
            
            model.title = model.title.PLClipFromPrefix(to: config.category.maxTitleCount)
            
            model.index = index
            model.isSelected = selectedIndex == index ? true : false
            model.maxTitleCount = config.category.maxTitleCount
            
            model.normalColor = config.category.normalColor
            model.selectedColor = config.category.selectedColor
            
            model.normalFont = config.category.normalFont
            model.selectFont = config.category.selectFont
            
            model.itemBackgroundColor = config.category.itemBackgroundColor
            model.itemExtendWidth = config.category.itemExtendWidth
            
            
            
            // item分割线 (最后一个直接隐藏)
            if index == (temp.categoryModels.count - 1) {
                model.itemSeparatorIsHidden = true
            } else {
                model.itemSeparatorIsHidden = config.itemSeparator.isHidden
                model.itemSeparatorBackgroundColor = config.itemSeparator.backgroundColor
                model.itemSeparatorWidth = config.itemSeparator.width
                model.itemSeparatorHeight = config.itemSeparator.height
                model.itemSeparatorCornerRadius = config.itemSeparator.cornerRadius
            }

            // badge的设置
            model.badgeIsHidden = config.badge.isHidden
            model.badgeBackgroundColor = config.badge.backgroundColor
            model.badgeOffset = config.badge.badgeOffset
            model.badgeIsDoc = config.badge.isDoc
            model.badgeTextColor = config.badge.badgeTextColor
            model.badgeTextFont = config.badge.badgeTextFont

            
            var itemWidth: CGFloat = 0
            // 说明用户没有强制设置了item的宽度
            if config.category.itemWidth <= 0 {
                let font = model.isSelected ? model.selectFont : model.normalFont
                
                itemWidth = model.itemExtendWidth + model.title.getWidth(font: font, height: font.pointSize + 5)
            } else {
                itemWidth = config.category.itemWidth
            }
            
            model.itemWidth = ceil(itemWidth)
            
            categoryModels.append(model)
            
            
            if index < selectedIndex {
                selectedItemCenterX += (model.itemWidth + config.category.itemSpacing)
            } else if index == selectedIndex {
                selectedItemCenterX += model.itemWidth / 2
                selectedtitleWidth = model.itemWidth - model.itemExtendWidth
            }
        }
        
        
        // 更改指示器的位置
        refreshIndicatorLocation(centerX: selectedItemCenterX, titleWidth: selectedtitleWidth)
    }
    
    /// 更改指示器的位置
    func refreshIndicatorLocation(centerX: CGFloat, titleWidth: CGFloat) {
        
        let height = config.indicator.height
        
        var width: CGFloat = 0
        if config.indicator.width > 0 {
            width = config.indicator.width
        } else {
            width = titleWidth
        }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.indicatorView.center.x = centerX
            self?.indicatorView.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
        }
    }

    
    /// 滚动选中的item到中央位置
    func layoutAndScrollToSelectedItem(_ index: Int) {
        
        var endIndex = 0
        
        let count = collectionView.numberOfItems(inSection: 0)
        
        if count > index {
            endIndex = index
        } else {
            endIndex = count - 1
        }
                collectionView.scrollToItem(at: IndexPath.init(row: endIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        

    }

    /// 刷新collectionView
    func reloadCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension PLCategoryBar {
   
    /// 更改某一个item的显示数据内容
    public func updateCategoryModel(_ model: PLCategoryBarModel, atIndex index: Int) {
        if categoryModels.count > index {
            categoryModels[index] = model
            collectionView.reloadItems(at: [IndexPath.init(row: index, section: 0)])
        }
    }
}



//MARK: - 对UICollectionView的代理
extension PLCategoryBar: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModels.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let model = categoryModels[indexPath.row]
        
        let itemHeight: CGFloat = self.frame.size.height - config.separator.height

        return CGSize.init(width: model.itemWidth, height: itemHeight)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCCategoryCell", for: indexPath) as! PLCategoryBarCell
        cell.model = categoryModels[indexPath.row]
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        categoryBarDidClickItem(at: indexPath.row)
        delegate?.categoryBar(categoryBar: self, didSelectItemAt: indexPath.row)
    }
}
