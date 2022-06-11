//
//  FloatingLabelInput.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

import UIKit

class FloatingLabelInput: UITextField {
    var floatingLabel: UILabel!
    var floatingLabelHeight: CGFloat = 14
    let defaultUnderlineColor = UIColor.white
    var bottomLine = UIView()
    
    @IBInspectable
    var _placeholder: String?
    
    @IBInspectable
    var placeholderColor: UIColor = UIColor.white.withAlphaComponent(0.6)
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.white {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
        
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.clear {
        didSet {
            self.floatingLabel.backgroundColor = .clear
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        //
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        //
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        //
        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor
        
        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.clear.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width, height: floatingLabel.frame.height)
            self.floatingLabel.textAlignment = .center
            self.addSubview(self.floatingLabel)
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true // Place our label 10 pts above the text field
            self.placeholder = ""
        }
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach { (view) in
                    guard view != self.bottomLine else { return }
                    view.removeFromSuperview()
                }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
    }
    
    public func setUnderlineColor(color: UIColor) {
        bottomLine.backgroundColor = color
    }
    
    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }
    
    public func setPlaceHolderColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
