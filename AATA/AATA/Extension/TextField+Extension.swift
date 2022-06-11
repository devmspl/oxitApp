//
//  TextField+Extension.swift
//  MyWaterController
//
//  Created by Uday Patel on 13/04/19.
//  Copyright © 2019 Uday Patel. All rights reserved.
//

import UIKit

///
extension UITextField {
    
    ///
    @IBInspectable var placeHolderColorJS: UIColor {
        get {
            return self.placeHolderColorJS
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder ?? "" : "", attributes: [NSAttributedString.Key.foregroundColor: newValue])
        }
    }
    
    ///
    func requiredFieldIndicatior() {
        guard var placeHolderText = self.placeholder else {
            return
        }
        if placeHolderText.last != "*" {
            placeHolderText.append("*")
        }
        let attString = NSMutableAttributedString(string: placeHolderText, attributes: nil)
        // attString.setAttributes([NSAttributedString.Key.font: self.font ?? Font(.installed(.sfProDisplayMedium), size: .standard(.size16)).instance, NSAttributedString.Key.baselineOffset: 0, NSAttributedString.Key.foregroundColor: UIColor.lightGray], range: NSRange(location: 0, length: placeHolderText.count - 1))
        // attString.setAttributes([NSAttributedString.Key.font: self.font ?? Font(.installed(.sfProDisplayMedium), size: .standard(.size16)).instance, NSAttributedString.Key.baselineOffset: 0, NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: placeHolderText.count - 1, length: 1))
        self.attributedPlaceholder = attString
    }
    
    ///
    func addLeftPaddingView() {
        let paddingView = UIView(frame:  CGRect(x: 0, y: 0, width: self.frame.height / 2, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    ///
    func addLeftPaddingImage(imageView: UIImageView) {
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
    ///
    func addRightPaddingButton(button: UIButton) {
        let paddingView = UIView.init()
        paddingView.bounds = button.bounds
        paddingView.addSubview(button)
        paddingView.clipsToBounds = true
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
