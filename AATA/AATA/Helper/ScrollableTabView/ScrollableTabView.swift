//
//  ScrollableTabView.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

import UIKit
/// ScrollingTabViewDatasource protocol methods
public protocol ScrollingTabViewDatasource {
    // MARK: - ScrollingTabViewDatasource
    ///
    func numberOfPagesInTabView(_ scrollingTabView: ScrollableTabView) -> Int
    
    ///
    func scrollableTabView(_ scrollableTabView: ScrollableTabView, tabViewForPageAtIndex index: Int) -> UILabel
    
    ///
    func scrollableTabView(_ scrollableTabView: ScrollableTabView, contentViewForPageAtIndex index: Int) -> UIView
}
///
public protocol ScrollingTabViewDelegate: class {
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didChangePageTo index: Int)
    
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didScrollPageTo index: Int)
}

/// ScrollTab for Deals and Product Listing
open class ScrollableTabView: UIView {
    
    // MARK: - Variables
    ///
    open var defaultPage: Int = 0
    ///
    open var tabSectionHeight: CGFloat = -1
    ///
    open var tabSectionBackgroundColor: UIColor = UIColor.white
    ///
    open var isGradientColor: Bool = false
    ///
    open var isSeparetorEnable: Bool = false
    open var isVerticalSeparetorEnable: Bool = false
    ///
    open var indicarorBackgroundColor: UIColor = .white
    ///
    open var tabSectionGradientLayer: CAGradientLayer = CAGradientLayer()
    ///
    open var contentSectionBackgroundColor: UIColor = UIColor.clear
    ///
    open var indicatorColor: UIColor =  UIColor.white
    /*UIColor.init(red: 58.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)*/
    ///
    open var pagingEnabled: Bool = true {
        didSet {
            contentSectionScrollView.isPagingEnabled = pagingEnabled
        }
    }
    ///
    open var headerTintColor: UIColor = UIColor.white
    ///
    open var currentHeaderColor: UIColor = UIColor.clear
    
    ///
    open var datasource: ScrollingTabViewDatasource?
    ///
    weak open var delegate: ScrollingTabViewDelegate?
    
    // MARK: Private Variables
    ///
    var tabSectionScrollView: ScrollView!
    ///
    fileprivate var tabSectionSeparetorView: UIView!
    ///
    var contentSectionScrollView: ScrollView!
    ///
    fileprivate var indicatorView: UIView!
    ///
    var activedScrollView: UIScrollView?
    
    ///
    fileprivate var tabViews: [Int: UILabel] = [:]
    ///
    fileprivate var contentViews: [Int: UIView] = [:]
    
    ///
    fileprivate var pageIndex: Int!
    ///
    fileprivate var prevPageIndex: Int?
    
    // MARK: - Datasource
    ///
    fileprivate var numberOfPages: Int = 0
    
    ///
    fileprivate func widthForTabAtIndex(_ index: Int) -> CGFloat {
        return tabViews[index]?.frame.width ?? 0
    }
    
    fileprivate func updatedIndicatorWidth(width: CGFloat) -> CGFloat {
        return width - 32.0
    }
    
    ///
    fileprivate func tabViewForPageAtIndex(_ index: Int) -> UILabel? {
        return datasource?.scrollableTabView(self, tabViewForPageAtIndex: index)
    }
    
    ///
    fileprivate func contentViewForPageAtIndex(_ index: Int) -> UIView? {
        return datasource?.scrollableTabView(self, contentViewForPageAtIndex: index)
    }
    
    // MARK: Init
    ///
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    ///
    fileprivate func initialize() {
        // init views
        tabSectionScrollView = ScrollView()
        contentSectionScrollView = ScrollView()
        indicatorView = UIView()
        
        self.addSubview(contentSectionScrollView)
        self.addSubview(tabSectionScrollView)
        //addSeparetorInTabSection()
        tabSectionScrollView.addSubview(indicatorView)
        
        tabSectionScrollView.isPagingEnabled = false
        tabSectionScrollView.showsHorizontalScrollIndicator = false
        tabSectionScrollView.showsVerticalScrollIndicator = false
        tabSectionScrollView.bounces = false
        tabSectionScrollView.delegate = self
        
        contentSectionScrollView.isPagingEnabled = pagingEnabled
        contentSectionScrollView.showsHorizontalScrollIndicator = false
        contentSectionScrollView.showsVerticalScrollIndicator = false
        contentSectionScrollView.bounces = false
        contentSectionScrollView.delegate = self
        
        tabSectionScrollView.delaysContentTouches = false
        contentSectionScrollView.delaysContentTouches = false
    }
    
    ///
    fileprivate func addSeparetorInTabSection() {
        tabSectionSeparetorView = UIView()
        tabSectionSeparetorView.frame = CGRect(x: 0, y: 10, width: self.frame.size.width, height: 2)
        tabSectionSeparetorView.backgroundColor = UIColor.red
        tabSectionScrollView.addSubview(tabSectionSeparetorView)
    }
    
    func scrollToIndex(index: Int) {
        moveToIndex(index, animated: false)
    }
    
    // MARK: - layoutSubviews
    ///
    open override func layoutSubviews() {
        super.layoutSubviews()
        stopScrolling()
        
        if isGradientColor {
            tabSectionScrollView.layer
                .insertSublayer(self.tabSectionGradientLayer, at: 0)
        } else {
            tabSectionScrollView.backgroundColor = self.tabSectionBackgroundColor
        }
        contentSectionScrollView.backgroundColor = self.contentSectionBackgroundColor
        indicatorView.backgroundColor = self.indicatorColor
        
        // Drop Shadow
        /*tabSectionScrollView.layer.shadowColor = UIColor.black.cgColor
         tabSectionScrollView.layer.shadowRadius = 3
         tabSectionScrollView.layer.shadowOffset = CGSize.zero// (width: 0, height: 2)
         tabSectionScrollView.layer.shadowOpacity = 0.5*/
        
        //tabSectionScrollView.setBottomShadow()
        tabSectionScrollView.clipsToBounds = false
        tabSectionScrollView.layer.masksToBounds = false
        
        // first time setup pages
        /*setupPages()
         // async necessarily
         DispatchQueue.main.async {
         // first time set defaule pageIndex
         self.initWithPageIndex(self.pageIndex ?? self.defaultPage)
         //self.isStarted = true
         
         // load pages
         self.lazyLoadPages()
         }*/
        
        reload()
    }
    
    ///
    func reload() {
        // first time setup pages
        setupPages()
        // async necessarily
        DispatchQueue.main.async {
            // first time set defaule pageIndex
            self.initWithPageIndex(self.pageIndex ?? self.defaultPage)
            //self.isStarted = true
            
            // load pages
            self.lazyLoadPages()
        }
    }
    
    // MARK: - Scrolling Action methods
    ///
    fileprivate func stopScrolling() {
        tabSectionScrollView.setContentOffset(tabSectionScrollView.contentOffset, animated: false)
        contentSectionScrollView.setContentOffset(contentSectionScrollView.contentOffset, animated: false)
    }
    
    /// initWithPageIndex
    ///
    /// - Parameter index:
    fileprivate func initWithPageIndex(_ index: Int) {
        // set pageIndex
        pageIndex = index
        prevPageIndex = pageIndex
        // init UI
        if numberOfPages != 0 {
            var tabOffsetX = 0 as CGFloat
            var contentOffsetX = 0 as CGFloat
            for i in 0 ..< index {
                tabOffsetX += widthForTabAtIndex(i)
                contentOffsetX += self.frame.width
            }
            // set default position of tabs, contents and indicator
            if tabSectionScrollView.contentSize.width > self.frame.width {
                tabOffsetX -= (self.frame.width - widthForTabAtIndex(index)) / 2
                let maxOffset = tabSectionScrollView.contentSize.width - self.frame.width
                if tabOffsetX < 0 {
                    tabOffsetX = 0
                } else if tabOffsetX > maxOffset {
                    tabOffsetX = maxOffset
                }
                tabSectionScrollView.contentOffset = CGPoint(x: tabOffsetX, y: tabSectionScrollView.contentOffset.y)
            }
            contentSectionScrollView.contentOffset = CGPoint(x: contentOffsetX, y: contentSectionScrollView.contentOffset.y)
            indicatorView.center.x = (tabViews[pageIndex]?.center.x) ?? 0
            indicatorView.frame.size.width = updatedIndicatorWidth(width: widthForTabAtIndex(pageIndex))
            updateTabAppearance(animated: false)
        }
    }
    
    /// lazyLoadPages
    fileprivate func lazyLoadPages() {
        if numberOfPages != 0 {
            let offset = 1
            let leftBoundIndex = pageIndex - offset > 0 ? pageIndex - offset : 0
            let rightBoundIndex = pageIndex + offset < numberOfPages ? pageIndex + offset : numberOfPages - 1
            var currentContentWidth: CGFloat = 0.0
            for i in 0 ..< numberOfPages {
                let width = self.frame.width
                if i >= leftBoundIndex && i <= rightBoundIndex {
                    let frame = CGRect(
                        x: currentContentWidth,
                        y: 0,
                        width: width,
                        height: contentSectionScrollView.frame.size.height)
                    insertPageAtIndex(i, frame: frame)
                }
                currentContentWidth += width
            }
            contentSectionScrollView.contentSize = CGSize(width: currentContentWidth, height: contentSectionScrollView.frame.height)
        }
    }
    
    /// insertPageAtIndex
    fileprivate func insertPageAtIndex(_ index: Int, frame: CGRect) {
        if contentViews[index] == nil {
            if let view = contentViewForPageAtIndex(index) {
                view.frame = frame
                contentViews[index] = view
                contentSectionScrollView.addSubview(view)
            }
        }
    }
    
    /// currentPageIndex
    fileprivate func currentPageIndex() -> Int {
        let width = self.frame.width
        var currentPageIndex = Int((contentSectionScrollView.contentOffset.x + (0.5 * width)) / width)
        if currentPageIndex < 0 {
            currentPageIndex = 0
        } else if currentPageIndex >= self.numberOfPages {
            currentPageIndex = self.numberOfPages - 1
        }
        return currentPageIndex
    }
    
    /// updateTabAppearance on scrolling
    fileprivate func updateTabAppearance(animated: Bool = true) {
        if numberOfPages != 0 {
            for i in 0 ..< numberOfPages {
                var alpha: CGFloat = 1.0
                var textColor: UIColor!
                
                let offset = abs(i - pageIndex)
                if offset > 0 {
                    alpha = 1.0
                    textColor = headerTintColor
                } else {
                    alpha = 1.0
                    textColor = currentHeaderColor
                }
                
                if let tab = self.tabViews[i] {
                    tab.textColor = textColor
                    if animated {
                        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                            tab.alpha = alpha
                            return
                        }, completion: nil)
                    } else {
                        tab.alpha = alpha
                    }
                }
            }
        }
    }
    
    /// setting up scroll pages
    fileprivate func setupPages() {
        numberOfPages = datasource?.numberOfPagesInTabView(self) ?? 0
        
        // clear all caches
        tabViews.removeAll()
        for subview in tabSectionScrollView.subviews {
            subview.removeFromSuperview()
        }
        contentViews.removeAll()
        for subview in contentSectionScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        if numberOfPages != 0 {
            // cache tabs and get the max height
            var maxTabHeight: CGFloat = 0
            for i in 0 ..< numberOfPages {
                if let tabView = tabViewForPageAtIndex(i) {
                    // get max tab height
                    if tabView.frame.height > maxTabHeight {
                        maxTabHeight = tabView.frame.height
                    }
                    tabViews[i] = tabView
                }
            }
            
            let tabSectionHeight = self.tabSectionHeight >= 0 ? self.tabSectionHeight : maxTabHeight + 2
            let contentSectionHeight = self.frame.size.height - tabSectionHeight
            
            // setup tabs first, and set contents later (lazyLoadPages)
            var tabSectionScrollViewContentWidth: CGFloat = 0
            for i in 0 ..< numberOfPages {
                if let tabView = tabViews[i] {
                    tabView.frame = CGRect(
                        origin: CGPoint(
                            x: tabSectionScrollViewContentWidth,
                            y: tabSectionHeight - tabView.frame.height),
                        size: tabView.frame.size)
                    if isVerticalSeparetorEnable && i != numberOfPages - 1 {
                        tabView.addBorders(edges: [.right], color: UIColor(red: 163.0/255.0, green: 214/255.0, blue: 188/255.0, alpha: 1.0), inset: 0, thickness: 2)
                    }

                    // bind event
                    tabView.tag = i
                    tabView.isUserInteractionEnabled = true
                    tabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ScrollableTabView.tabViewDidClick(_:))))
                    tabSectionScrollView.addSubview(tabView)
                }
                tabSectionScrollViewContentWidth += widthForTabAtIndex(i)
            }
            
            if maxTabHeight >= 0 {
                let indicatorFrame = CGRect(x: 0, y: maxTabHeight + 8, width: updatedIndicatorWidth(width: (tabViewForPageAtIndex(pageIndex ?? 0)?.frame.width ?? 0)), height: 3.5)
                
                if isSeparetorEnable {
                    /* Code for separator  */
                    let indicatorBGFrame = CGRect(x: 0, y: maxTabHeight, width: tabSectionScrollViewContentWidth, height: 1.5)
                    
                    let indicarorBackgroundView = UIView(frame: indicatorBGFrame)
                    
                    indicarorBackgroundView.alpha = 0.4 //
                    indicarorBackgroundView.backgroundColor = indicarorBackgroundColor //
                    tabSectionScrollView.addSubview(indicarorBackgroundView)
                    /* Code for separator  */
                }
                
                indicatorView.frame = indicatorFrame
                tabSectionScrollView.addSubview(indicatorView)
            }
            
            // reset the fixed size of tab section
            tabSectionScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: tabSectionHeight)
            tabSectionScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ScrollableTabView.tabSectionScrollViewDidClick(_:))))
            tabSectionScrollView.contentSize = CGSize(width: tabSectionScrollViewContentWidth, height: tabSectionHeight)
            
            // reset the fixed size of content section
            contentSectionScrollView.frame = CGRect(x: 0, y: tabSectionHeight, width: self.frame.size.width, height: contentSectionHeight)
        }
    }
    
    // MARK: - Tab Clicking Control
    ///
    @objc func tabViewDidClick(_ sender: UITapGestureRecognizer) {
        activedScrollView = tabSectionScrollView
        moveToIndex(sender.view?.tag ?? 0, animated: true)
    }
    
    ///
    @objc func tabSectionScrollViewDidClick(_ sender: UITapGestureRecognizer) {
        activedScrollView = tabSectionScrollView
        moveToIndex(pageIndex, animated: true)
    }
    
    ///
    fileprivate func moveToIndex(_ index: Int, animated: Bool) {
        if index >= 0 && index < numberOfPages {
            if pagingEnabled {
                // force stop
                stopScrolling()
                
                if activedScrollView == nil || activedScrollView == tabSectionScrollView {
                    activedScrollView = contentSectionScrollView
                    contentSectionScrollView.scrollRectToVisible(CGRect( origin: CGPoint(x: self.frame.width * CGFloat(index), y: 0), size: self.frame.size), animated: true)
                }
            }
            
            if prevPageIndex != index {
                prevPageIndex = index
                // callback
                delegate?.scrollableTabView(self, didChangePageTo: index)
            }
        }
    }
}

// MARK: - Extension Implementing UIScrollView Delegate Callbacks
extension ScrollableTabView: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    /// scrolling animation begin by dragging
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // stop current scrolling before start another scrolling
        stopScrolling()
        // set the activedScrollView
        activedScrollView = scrollView
    }
    
    /// scrolling animation stop with decelerating
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        moveToIndex(currentPageIndex(), animated: true)
    }
    
    /// scrolling animation stop without decelerating
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            moveToIndex(currentPageIndex(), animated: true)
        }
    }
    
    /// scrolling animation stop programmatically
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    /// method for before scrolling
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = currentPageIndex()
        
        if scrollView == activedScrollView {
            let speed = self.frame.width / widthForTabAtIndex(currentIndex)
            let halfWidth = self.frame.width / 2
            
            var tabsWidth: CGFloat = 0
            var contentsWidth: CGFloat = 0
            for i in 0 ..< currentIndex {
                tabsWidth += widthForTabAtIndex(i)
                contentsWidth += self.frame.width
            }
            
            /*if scrollView == tabSectionScrollView {
             contentSectionScrollView.contentOffset.x = ((tabSectionScrollView.contentOffset.x + halfWidth - tabsWidth) * speed) + contentsWidth - halfWidth
             }*/
            
            if scrollView == contentSectionScrollView {
                let offset = ((contentSectionScrollView.contentOffset.x + halfWidth - contentsWidth) / speed) + tabsWidth - halfWidth
                if tabSectionScrollView.contentSize.width > self.frame.width {
                    let maxOffset = tabSectionScrollView.contentSize.width - self.frame.width
                    if offset < 0 {
                        tabSectionScrollView.contentOffset.x = 0
                    } else if offset > maxOffset {
                        tabSectionScrollView.contentOffset.x = maxOffset
                    } else {
                        tabSectionScrollView.contentOffset.x = offset
                    }
                }
                indicatorView.center.x = (tabViews[pageIndex]?.center.x) ?? 0 // offset + halfWidth
                indicatorView.frame.size.width = updatedIndicatorWidth(width: widthForTabAtIndex(currentIndex))
                
            }
            updateTabAppearance()
        }
        
        if pageIndex != currentIndex {
            // set index
            pageIndex = currentIndex
            
            // lazy loading
            lazyLoadPages()
            
            // callback
            delegate?.scrollableTabView(self, didScrollPageTo: currentIndex)
        }
    }
}

class ScrollView : UIScrollView {
    
    var isTouchInside: Bool = false
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = gestureRecognizer.view as? UIScrollView {
            for subView in scrollView.subviews {
                for innerSubView in subView.subviews where innerSubView as? UITableView != nil {
                    for inInnnerSubView in innerSubView.subviews where inInnnerSubView as? UITableViewCell != nil {
                        let point = gestureRecognizer.location(in: inInnnerSubView)
                        if inInnnerSubView.bounds.contains(point) || isTouchInside {
                            return false
                        } else {
                            return true
                        }
                    }
                }
            }
        }
        return true
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        isTouchInside = false
        for subView in self.subviews {
            for innerSubView in subView.subviews where innerSubView as? UITableView != nil {
                for inInnnerSubView in innerSubView.subviews where inInnnerSubView as? UITableViewCell != nil {
                    for touch in touches {
                        let point = touch.location(in: inInnnerSubView)
                        if inInnnerSubView.bounds.contains(point) {
                            isTouchInside = true
                        }
                        if isTouchInside {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
}
