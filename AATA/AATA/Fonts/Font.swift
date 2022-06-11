//
//  Font.swift
//  jsw
//
//  Created by jignesh on 29/07/17.
//  Copyright © 2017 Jignesh Patel. All rights reserved.
//

import UIKit

struct Font {
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum FontName: String {
        case sfProDisplayLight        = "SFProDisplay-Light"
        case sfProDisplayRegular      = "SFProDisplay-Regular"
        case sfProDisplayMedium       = "SFProDisplay-Medium"
        case sfProDisplaySemiBold     = "SFProDisplay-Semibold"
        case sfProDisplayBold         = "SFProDisplay-Bold"
    }
    
    enum StandardSize: Double {
        case size20 = 20.0
        case size18 = 18.0
        case size17 = 17.0
        case size16 = 16.0
        case size14 = 14.0
        case size12 = 12.0
        case size10 = 10.0
    }
    
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value), weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}
