//
//  ScrollableTabMenu.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

import UIKit

///
protocol TabIdentifier: class {
    ///
    var index: Int { get set }
}

/// Used for displaying Multiple tabs under Transactions.
class ScrollableTabMenu: NSObject {
    // MARK: - Variables
    ///
    var controllerArray: [UIViewController] = []
    ///
    var dataList: [[String: Any]] = []
    ///
    var minItemOnScreen: Int = 2
    ///
    var offset: CGFloat = 0
    ///
    weak var controller: UIViewController?
    
    // MARK: - Initialization method
    ///
    convenience init(with scrollableTab: ScrollableTabView, dataArray: [[String: Any]], controller: UIViewController, innerControllers: [UIViewController]) {
        self.init()
        self.controller = controller
        scrollableTab.datasource = self
        scrollableTab.tabSectionBackgroundColor = .clear
        scrollableTab.indicatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollableTab.currentHeaderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollableTab.headerTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        scrollableTab.defaultPage = 0
        
        dataList = dataArray
        setupControllerPage(innerControllers)
        
        scrollableTab.reload()
    }
    
    /// setting ViewController's Based on Product categories
    func setupControllerPage(_ controllers: [UIViewController]) {
        for (index, controller) in controllers.enumerated() {
            (controller as? TabIdentifier)?.index = index
            controllerArray.append(controller)
        }
    }
}

// MARK: - Extension Implementing Scrolling TabView Datasource Callbacks
extension ScrollableTabMenu: ScrollingTabViewDatasource {
    ///
    func numberOfPagesInTabView(_ scrollingTabView: ScrollableTabView) -> Int {
        return controllerArray.count
    }
    
    ///
    func scrollableTabView(_ scrollableTabView: ScrollableTabView, tabViewForPageAtIndex index: Int) -> UILabel {
        var headerText: String = ""
        headerText = dataList[index]["name"] as? String ?? ""
        
        let headerFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0)
        var labelWidth: CGFloat = 0
        
        if controllerArray.count == minItemOnScreen {
            labelWidth = (UIScreen.main.bounds.width - offset) / CGFloat(controllerArray.count)
        } else {
            labelWidth = headerText.widthOfString(usingFont: headerFont) + 40
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 35))
        label.textAlignment = .center
        label.textColor = .white
        label.font = headerFont
        label.text = headerText
        return label
    }
    
    ///
    func scrollableTabView(_ scrollableTabView: ScrollableTabView, contentViewForPageAtIndex index: Int) -> UIView {
        if index % 2 == 0 {
            controllerArray[index].view.backgroundColor = .clear
        } else {
            controllerArray[index].view.backgroundColor = .clear
        }
        return controllerArray[index].view
    }
}

// MARK: - String Extensions
extension String {
    /// Calculates Width of String widthOfString
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
