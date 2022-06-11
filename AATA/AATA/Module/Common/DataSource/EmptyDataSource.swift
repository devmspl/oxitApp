//
//  EmptyDataSource.swift
//  PetBubs
//
//  Created by Hardik Kothari on 28/04/17.
//  Copyright © 2017 Credencys Solutions Inc. All rights reserved.
//

import UIKit
///
class EmptyDataSource: NSObject {
    ///
    var placeholderMessage: String! = ""
}

///
extension EmptyDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return EmptyDataSourceView.getPlaceholderView(with: placeholderMessage, parentView: tableView)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.frame.height - (tableView.tableHeaderView?.frame.height ?? 0)
    }
}

///
class EmptyDataSourceView: NSObject {
    class func getPlaceholderView(with message: String!, parentView: UIView!, fontSize: CGFloat = 16.0) -> UIView! {
        let placeHolderView = UIView(frame: parentView.bounds)
        placeHolderView.clipsToBounds = true

        let padding = CGFloat(20.0)
        let label = UILabel(frame: CGRect(x: padding, y: 0, width: parentView.bounds.width - (padding * 2), height: 100))
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = .black
        label.text = message
        label.adjustsFontSizeToFitWidth = true
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        placeHolderView.addSubview(label)
        return placeHolderView
    }
}
