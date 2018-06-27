//
//  GPTextView.swift
//  GPLibs
//
//  Created by Mehmet Çakır on 07/08/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit


open class GPTextView: UIView, UITextViewDelegate {
    
    @IBInspectable var animatedPlaceholder:Bool = true
    @IBInspectable var required:Bool = false
    @IBInspectable var errorText:String = ""
    @IBInspectable var requiredColor:UIColor = UIColor(hex:"D0011B")
    @IBInspectable var shakeEnabled:Bool = true
    @IBInspectable var placeholder:String = ""
    @IBInspectable var placeholderColor:UIColor = UIColor(hex:"BFBFC7")
    @IBInspectable var titleColor:UIColor = UIColor(hex:"9391A8")
    @IBInspectable var cursorColor:UIColor = UIColor(hex:"9391A8")
    @IBInspectable var textColor:UIColor = UIColor(hex:"9391A8")
    @IBInspectable var background:UIColor = UIColor.clear
    @IBInspectable var maxCharLength:Int = -1
    
    fileprivate var placeholderRequiredLabel:UILabel?
    fileprivate var placeholderFont:UIFont = UIFont.systemFont(ofSize: 19.0)
    fileprivate var titleFont:UIFont = UIFont.systemFont(ofSize: 14.0)
    fileprivate var textFont:UIFont = UIFont.systemFont(ofSize: 14.0)
    fileprivate var textViewHeightConst:NSLayoutConstraint?
    fileprivate var textViewTopConst:NSLayoutConstraint?
    fileprivate var placeholderHeightConst:NSLayoutConstraint?
    fileprivate var errorLabel: UILabel?
    fileprivate var borderStyle:UITextBorderStyle = UITextBorderStyle.none
    fileprivate var placeholderLabel:UILabel?
    public var gpTextView:UITextView?
    
    fileprivate var autocapitalizationType:UITextAutocapitalizationType = .none
    fileprivate var autocorrectionType:UITextAutocorrectionType = .no
    fileprivate var spellCheckingType:UITextSpellCheckingType = .no
    fileprivate var keyboardType:UIKeyboardType = .default
    fileprivate var keyboardReturnType:UIReturnKeyType = .default
    fileprivate var keyboardAppearance:UIKeyboardAppearance = .default
    //fileprivate var rootView:UIView?
    
    fileprivate var placeholderAnimateUp:Bool = false
    
    var discardChars:Array<Character> = []
    
    public var textViewShouldBeginEditing: () -> () = {}
    public var textViewEndEditing: () -> () = {}
    public var textViewValueChanged: (CGFloat) -> () = {_ in}
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var anim:GPAnimation?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
//    open var text:String? {
//        didSet{
//            self.gpTextView?.text = text
//            textfieldValueChanged()
//        }
//    }
    
    open var characterCount: Int?
    
    func initView() {
        anim = GPAnimation(self)
        //self.background = UIColor.clear
        //self.rootView = UIView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.height))
        //        self.layoutIfNeeded()
        //        self.rootView!.backgroundColor = UIColor.clear
        //        self.addSubview(self.rootView!)
        gpTextView = UITextView()
        gpTextView!.delegate = self
        //gpTextFiled!.addTarget(self, action: #selector(textfieldValueChanged), for: UIControlEvents.allEvents)
        //gpTextView!.borderStyle = self.borderStyle
        gpTextView?.translatesAutoresizingMaskIntoConstraints = false
        gpTextView!.textColor = self.textColor
        gpTextView!.tintColor = self.cursorColor
        gpTextView!.font = self.textFont
        gpTextView!.textAlignment = .natural
        
        gpTextView!.isScrollEnabled = false
        gpTextView!.autocapitalizationType = self.autocapitalizationType
        gpTextView!.autocorrectionType = self.autocorrectionType
        gpTextView!.spellCheckingType = self.spellCheckingType
        gpTextView!.keyboardType = self.keyboardType
        gpTextView!.keyboardAppearance = keyboardAppearance
        gpTextView!.returnKeyType = self.keyboardReturnType
        
        gpTextView!.isUserInteractionEnabled = true
        gpTextView!.backgroundColor = self.background
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:12, height:self.gpTextView!.frame.height))
//        gpTextView!.leftView = paddingView
//        gpTextView!.rightView = paddingView
        //gpTextView!.leftViewMode = .always
        
        let padding = self.gpTextView?.textContainer.lineFragmentPadding
        self.gpTextView?.textContainerInset = UIEdgeInsetsMake(0, -padding!, 0, -padding!)
        
        self.addSubview(gpTextView!)
        self.textViewHeightConst = UIHelper.createHeightConstraint(item: gpTextView!, height: ((self.frame.size.height/3)*2)-3)
        self.textViewTopConst = UIHelper.createTopConstraint(item: gpTextView!, toItem: self, constant: 23.0)
        
        NSLayoutConstraint.activate([textViewHeightConst!,UIHelper.createLeadingConstraint(item: gpTextView!, toItem: self, constant: 16.0), UIHelper.createTrailingConstraint(item: gpTextView!, toItem: self, constant: -16.0), UIHelper.createBottomConstraint(item: gpTextView!, toItem: self, constant: 0.0), textViewTopConst!])
        
        addPlaceholder()
    }
    
    func addRequiredLabel() {
        placeholderRequiredLabel = UILabel()
        placeholderRequiredLabel!.text = "*"
        placeholderRequiredLabel!.textColor = self.requiredColor
        placeholderRequiredLabel!.font = placeholderFont
        placeholderRequiredLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderRequiredLabel!)
        NSLayoutConstraint.activate([UIHelper.createIncrecentWidthConstraint(item: placeholderRequiredLabel!, width: 0.0),UIHelper.createHorizontalSpacingConstraint(item: placeholderRequiredLabel!, toItem: self.placeholderLabel!, constant: 3.0), UIHelper.createCenterVerticalConstraint(item: placeholderRequiredLabel!, toItem: self.placeholderLabel!, constant: 0.0), UIHelper.createIncrecentHeightConstraint(item: placeholderRequiredLabel!, height: 0.0)])
    }
    
    func addPlaceholder() {
        //guard let labelText = placeholder else { return }
        
        placeholderLabel = UILabel()
        placeholderLabel!.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel!.isUserInteractionEnabled = false
        placeholderLabel!.text = placeholder
        placeholderLabel!.textColor = placeholderColor
        placeholderLabel!.backgroundColor = UIColor.clear
        self.addSubview(placeholderLabel!)
        self.placeholderHeightConst = UIHelper.createHeightConstraint(item: placeholderLabel!, height: self.frame.size.height)
        NSLayoutConstraint.activate([UIHelper.createIncrecentWidthConstraint(item: placeholderLabel!, width: 0.0), placeholderHeightConst!,UIHelper.createLeadingConstraint(item: placeholderLabel!, toItem: self, constant: 16.0), UIHelper.createDecrescentTrailingConstraint(item: placeholderLabel!, toItem: self, constant: 0.0), UIHelper.createTopConstraint(item: placeholderLabel!, toItem: self, constant: 0.0)])
        
        if required {
            self.addRequiredLabel()
        }
        
        errorLabel = UILabel()
        errorLabel!.text = errorText
        errorLabel!.alpha = 0.0
        errorLabel!.backgroundColor = UIColor.clear
        errorLabel!.font = UIFont.systemFont(ofSize: 12.0)
        errorLabel!.textColor = UIColor(hex:"#D0011B")
        errorLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(errorLabel!)
        NSLayoutConstraint.activate([UIHelper.createIncrecentWidthConstraint(item: errorLabel!, width: 0.0),UIHelper.createHorizontalSpacingConstraint(item: errorLabel!, toItem: !required ? self.placeholderLabel! : placeholderRequiredLabel!, constant: 4.0), UIHelper.createDecrescentTrailingConstraint(item: errorLabel!, toItem: self, constant: 0.0), UIHelper.createTopConstraint(item: errorLabel!, toItem: self, constant: 15.0)/*, UIHelper.createBottomConstraint(item: errorLabel!, toItem: self, constant: 0.0)*/])
        
    }
    
    //MARK:- UITextView Delegate -

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textViewText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        print(textViewText)
        if textViewText.characters.count == 0 {
            if self.placeholderAnimateUp {
                self.animatePlaceholderDown()
            }
            if self.required {
                self.placeholderRequiredLabel?.isHidden = false
            }
        }
        else {
            if !self.placeholderAnimateUp {
                self.animatePlaceholderUp()
            }
            self.placeholderRequiredLabel?.isHidden = true
        }
        
        if self.errorLabel != nil {
            self.errorLabel!.alpha = 0.0
        }
        
        
        print("\(self.heightForView(text: textViewText, font: UIFont.systemFont(ofSize: 19.0, weight: UIFontWeightMedium), width: self.frame.size.width-32))")
        self.textViewValueChanged(self.heightForView(text: textViewText, font: UIFont.systemFont(ofSize: 19.0, weight: UIFontWeightMedium), width: self.frame.size.width-32))
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.textViewHeightConst?.constant = (self.heightForView(text: textViewText, font: UIFont.systemFont(ofSize: 19.0, weight: UIFontWeightMedium), width: self.frame.size.width-32))
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
//        if self.errorLabel != nil {
//            self.errorLabel!.alpha = 0.0
//        }
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.textViewShouldBeginEditing()
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewEndEditing()
    }
    
    //MARK:- UITextField Delegate -
    
    open func getText() -> String? {
        return self.gpTextView?.text
    }
    
    private func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
}

extension GPTextView {
    func animatePlaceholderUp() {
        self.placeholderAnimateUp = true
        if animatedPlaceholder {
            UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseOut, animations: {
                self.placeholderLabel?.alpha = 0.5
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
            
            UIView.animate(withDuration: 0.08, delay: 0.07, options: .curveEaseOut, animations: {
                self.placeholderLabel?.alpha = 1.0
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.textViewTopConst?.constant = 35
                if self.placeholderLabel != nil {
                    self.placeholderHeightConst!.constant -= 26
                    self.placeholderLabel?.font = self.titleFont
                    self.placeholderLabel?.textColor = self.titleColor
                }
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
        }
        else {
            if self.placeholderLabel != nil {
                self.placeholderLabel?.alpha = 0.0
            }
        }
    }
    
    func animatePlaceholderDown() {
        self.placeholderAnimateUp = false
        if animatedPlaceholder {
            UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseOut, animations: {
                if self.placeholderLabel != nil {
                    self.placeholderLabel!.alpha = 0.5
                }
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
            
            UIView.animate(withDuration: 0.08, delay: 0.07, options: .curveEaseOut, animations: {
                if self.placeholderLabel != nil {
                    self.placeholderLabel!.alpha = 1.0
                }
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.textViewHeightConst!.constant = 51.75
                self.textViewTopConst?.constant = 23
                if self.placeholderLabel != nil {
                    self.placeholderHeightConst!.constant = 69
                    self.placeholderLabel!.font = self.placeholderFont
                    self.placeholderLabel!.textColor = self.placeholderColor
                    
                }
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
        }
        else{
            if self.placeholderLabel != nil {
                self.placeholderLabel?.alpha = 1.0
            }
        }
    }
    
    open func showError() {
        if errorLabel != nil && self.errorLabel!.text!.characters.count > 0 {
            self.errorLabel!.alpha = 0.0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.errorLabel!.alpha = 1.0
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
        }
    }
    
    open func hideError() {
        if errorLabel != nil && self.errorLabel!.alpha > CGFloat(0.0) && self.errorLabel!.text!.characters.count > 0 {
            self.errorLabel!.alpha = 1.0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.errorLabel!.alpha = 0.0
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
            })
        }
    }
    
    open func shake() {
        if errorLabel != nil {
            self.errorLabel!.alpha = 0.0
        }
        anim?.shake()
        
        showError()
    }
    
    func setTextFieldFont(_ fontName:String, fontSize:CGFloat) {
        self.textFont = UIFont(name: fontName, size: fontSize)!
    }
    
    func setTitleFont(_ fontName:String, fontSize:CGFloat) {
        self.titleFont = UIFont(name: fontName, size: fontSize)!
    }
    
    func setPlaceholderFont(_ fontName:String, fontSize:CGFloat) {
        self.placeholderFont = UIFont(name: fontName, size: fontSize)!
    }
    
    func setBorderStyle(_ style:UITextBorderStyle) {
        self.borderStyle = style
    }
    
//    open func gpTextView() -> UITextView {
//        return self.gpTextView!
//    }
    open func setTextFieldText(_ text:String) {
        self.gpTextView?.text = text
        if !text.isEmpty {
            if !self.placeholderAnimateUp {
                self.animatePlaceholderUp()
            }
            self.placeholderRequiredLabel?.isHidden = true
        }
    }
    
    open func setPlaceholderText(_ placeholder:String) {
        self.placeholderLabel?.text = placeholder
    }
    
    open func setGPTextColor(_ hexColor:String) {
        self.gpTextView!.textColor = UIColor(hex:hexColor)
    }
    
    open func setGPTextFont(_ gpFont:UIFont) {
        self.gpTextView!.font = gpFont
    }
    
    open func setGPErrorText(_ errText:String) {
        self.errorLabel!.text = errText
    }
    
    open override func resignFirstResponder() -> Bool {
        self.gpTextView?.resignFirstResponder()
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        self.gpTextView?.becomeFirstResponder()
        return true
    }
    
    open func discardChars(_ discardChars:Array<Character>) { self.discardChars = discardChars }
    open func autocapitalizationType(_ autocapitalizationType:UITextAutocapitalizationType){ self.gpTextView?.autocapitalizationType = autocapitalizationType }
    open func autocorrectionType(_ autocorrectionType:UITextAutocorrectionType){ self.gpTextView?.autocorrectionType = autocorrectionType }
    open func spellCheckingType(_ spellCheckingType:UITextSpellCheckingType){ self.gpTextView?.spellCheckingType = spellCheckingType }
    open func keyboardType(_ keyboardType:UIKeyboardType){ self.gpTextView?.keyboardType = keyboardType }
    open func keyboardReturnType(_ keyboardReturnType:UIReturnKeyType){ self.gpTextView?.returnKeyType = keyboardReturnType }
    open func keyboardAppearance(_ keyboardAppearance:UIKeyboardAppearance){ self.gpTextView?.keyboardAppearance = keyboardAppearance }
}
