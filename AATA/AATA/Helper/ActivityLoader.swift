//
//  ActivityLoader.swift
//  MyWaterController
//
//  Created by Uday Patel on 28/09/21.
//

import Foundation
import UIKit

/// Custom ActivityLoader
class ActivityLoader {
    // MARK: - Variables
    /// Container view for indicator
    var container: UIView = UIView()
    /// Backgroun view for activity indicator
    var loadingView: UIView = UIView()
    /// Activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    // MARK: - Helper methodes
    /// Show customized activity indicator
    ///
    /// - Parameter uiView: add activity indicator to this view
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
            activityIndicator.style = UIActivityIndicatorView.Style.gray
        }
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            self.container.addSubview(self.loadingView)
            uiView.addSubview(self.container)
            self.activityIndicator.startAnimating()
        }
    }
    /// Hide activity indicator
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.container.removeFromSuperview()
        }
    }
}
