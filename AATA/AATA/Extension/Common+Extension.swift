//
//  Common+Extension.swift
//  MyWaterController
//
//  Created by Uday Patel on 13/04/19.
//  Copyright © 2019 Uday Patel. All rights reserved.
//

import UIKit
import Toast_Swift
import SideMenu
import AWSMobileClient
import Cartography

///
extension Notification.Name {
    ///
    static let refreshDeviceList = Notification.Name("RefreshDeviceList")
    ///
    static let reloadSettingsPage = Notification.Name("reloadSettingsPage")
    ///
    static let showLoader = Notification.Name("showLoader")
    ///
    static let hideLoader = Notification.Name("hideLoader")
}

///
extension Bundle {
    ///
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    ///
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

///
extension NSObject {
    ///
    func errorHandler(_ response: [String: Any]?) {
        let message = (response?["message"] as? String) ?? R.string.localizable.somethingWentWrongPleaseTryAgainLater()
        let windows = UIApplication.shared.windows
        if windows.count > 0 {
            windows.first?.rootViewController?.toast(message)
        }
    }
}

///
extension UIViewController {
    ///
    func showAlert(_ title: String, _ message: String, _ buttons: [String], _ isHaveTextInput: Bool = false, _ keyboardType: UIKeyboardType = .alphabet, _ completion: @escaping(_ actionType: String, _ textFieldValue: String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if isHaveTextInput {
            alert.addTextField(configurationHandler: { textField in
                textField.keyboardType = keyboardType
            })
        }
        for button in buttons {
            let action: UIAlertAction!
            guard button.trim().count > 0 else { continue }
            action = UIAlertAction.init(title: button, style: .default, handler: { action in
                if isHaveTextInput {
                    let answer = alert.textFields?[0]
                    print(answer?.text ?? "")
                    completion(action.title ?? "", answer?.text ?? "")
                } else {
                    completion(action.title ?? "", "")
                }
            })
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Side Menu Methods
    ///
    func openSideMenu() {
        // guard let menu = R.storyboard.sideMenu().instantiateViewController(withIdentifier: "SideMenu") as? SideMenuNavigationController else { return }
        // Define the menu
        // menu.statusBarEndAlpha = 0
        // menu.settings = makeSettings()
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        // present(menu, animated: true, completion: nil)
    }
    
    func makeSettings() -> SideMenuSettings {
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.presentationStyle.presentingEndAlpha = 0.6
        settings.menuWidth = UIScreen.main.bounds.width * 0.8
        settings.statusBarEndAlpha = 0
        return settings
    }
    
    // MARK: - Alert Method
    ///
    func showAlert(_ title: String, _ message: String, _ leftButton: String, _ rightButton: String, _ completion: @escaping(Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1: UIAlertAction!
        let action2: UIAlertAction!
        if leftButton.trim().count > 0 {
            action1 = UIAlertAction.init(title: leftButton, style: .default, handler: { (_) in
                completion(false)
            })
            alert.addAction(action1)
        }
        
        if rightButton.trim().count > 0 {
            action2 = UIAlertAction.init(title: rightButton, style: .default, handler: { (_) in
                completion(true)
            })
            alert.addAction(action2)
        }
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    ///
    func toast(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view.makeToast(message)
        }
    }
    
    ///
    func handleAWSError(_ error: AWSMobileClientError, _ completion: @escaping(String) -> Void) {
        switch error {
        case .aliasExists(let message), .codeDeliveryFailure(let message), .codeMismatch(let message), .expiredCode(let message), .groupExists(let message), .internalError(let message), .invalidLambdaResponse(let message), .invalidOAuthFlow(let message), .invalidParameter(let message), .invalidPassword(let message), .invalidUserPoolConfiguration(let message), .limitExceeded(let message), .mfaMethodNotFound(let message), .notAuthorized(let message), .passwordResetRequired(let message), .resourceNotFound(let message), .scopeDoesNotExist(let message), .softwareTokenMFANotFound(let message), .tooManyFailedAttempts(let message), .tooManyRequests(let message), .unexpectedLambda(let message), .userLambdaValidation(let message), .userNotConfirmed(let message), .userNotFound(let message), .usernameExists(let message), .unknown(let message), .notSignedIn(let message), .identityIdUnavailable(let message), .guestAccessNotAllowed(let message), .federationProviderExists(let message), .cognitoIdentityPoolNotConfigured(let message), .unableToSignIn(let message), .invalidState(let message), .userPoolNotConfigured(let message), .userCancelledSignIn(let message), .badRequest(let message), .expiredRefreshToken(let message), .errorLoadingPage(let message), .securityFailed(let message), .idTokenNotIssued(let message), .idTokenAndAcceessTokenNotIssued(let message), .invalidConfiguration(let message), .deviceNotRemembered(let message):
            completion(message)
        }
    }
}

///
extension String {
    ///
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// validate an email for the right format
    func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    ///
    func isValidPassword() -> Bool {
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    /// This function is use to entered number is valid phone number or not.
    ///
    /// - Parameter value: number string
    /// - Returns: boolian value
    func isPhoneNumber() -> Bool {
        if (self.hasPrefix("6") || self.hasPrefix("7") || self.hasPrefix("8") || self.hasPrefix("9")) && self.count == 10 {
            return true
        } else {
            return false
        }
    }
    
    /// Convert HTML to Plain Text in Swift.
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    /// Convert HTML to Plain Text in Swift.
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    /// Hyper Link.
    func toHyperLink() -> NSAttributedString {
        return NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    /// is String An Number check.
    func isStringAnNumber() -> Bool {
        return Double(self) != nil
    }
    
    ///
    var jsonStringToDictionary: [String: Any] {
        guard let jsonData = self.data(using: .utf8) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any] else { return [:] }
        return dictionary
    }
    
    ///
    func convertDateStringToDate(currentDateFormatter: String) -> Date {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = currentDateFormatter
        // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}

///
struct Number {
    ///
    static let formatterWithSepator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        //***formatter.locale = NSLocale(localeIdentifier: "en_IN")***//
        return formatter
    }()
}

///
extension UIView {
    /// Toast view to show message.
    ///
    /// - Parameters:
    ///   - message: message string.
    ///   - duration: duration time.
    func toast(message: String, duration: Double = 2.0) {
        self.makeToast(message, duration: duration)
    }
    
    func addDashBorder() {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.lightGray.cgColor
        yourViewBorder.lineDashPattern = [6, 6]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}

///
extension Encodable {
    ///
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

//let date = Date()
//let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") // Set output formate
///
extension Date {
    ///
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.timeZone = TimeZone.current
        return dateformat.string(from: self)
    }
}

extension UITapGestureRecognizer {
    ///
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension String {
    ///
    func convertDate(currentDateFormatter: String, inputTimeZone: TimeZone? = nil, requiredDateFormatter: String, requiredTZ: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = currentDateFormatter
        // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let tz = inputTimeZone {
            dateFormatter.timeZone = tz
        }
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = requiredDateFormatter
        if let rqTz = requiredTZ {
            dateFormatter.timeZone = rqTz
        }
        // "dd/MM/yyyy | hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    ///
    func convertDateStringToDate(currentDateFormatter: String, inputTimeZone: TimeZone? = nil) -> Date {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = currentDateFormatter
        // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let tz = inputTimeZone {
            dateFormatter.timeZone = tz
        }
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}

extension Date {
    ///
    func dateToString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        // set locale to reliable US_POSIX
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func dateToGraphString() -> String {
        return self.dateToString("yyyy-MM-dd hh:mm a")
    }
}

extension Collection {
    ///
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
    
    ///
    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
            return self[index]
        }
    }
    
    ///
    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    ///
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
    
    ///
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}

extension UIView {
    ///
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension String {
    ///
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    ///
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
