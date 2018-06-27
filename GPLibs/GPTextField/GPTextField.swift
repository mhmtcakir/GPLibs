//
//  GPView.swift
//  GPLib
//
//  Created by Mehmet Cakir on 03/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit


open class GPTextField: UIView, UITextFieldDelegate {
    
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
    @IBInspectable var extraPlaceholderInfo:String = ""
    
    fileprivate var placeholderRequiredLabel:UILabel?
    fileprivate var placeholderFont:UIFont = UIFont.systemFont(ofSize: 19.0)
    fileprivate var titleFont:UIFont = UIFont.systemFont(ofSize: 14.0)
    fileprivate var textFont:UIFont = UIFont.systemFont(ofSize: 14.0)
    fileprivate var textFieldHeightConst:NSLayoutConstraint?
    fileprivate var placeholderHeightConst:NSLayoutConstraint?
    fileprivate var errorLabel: UILabel?
    fileprivate var borderStyle:UITextBorderStyle = UITextBorderStyle.none
    fileprivate var placeholderLabel:UILabel?
    fileprivate var placeholderFormatLabel:UILabel?
    fileprivate var gpTextFiled:UITextField?
    
    fileprivate var autocapitalizationType:UITextAutocapitalizationType = .none
    fileprivate var autocorrectionType:UITextAutocorrectionType = .no
    fileprivate var spellCheckingType:UITextSpellCheckingType = .no
    fileprivate var keyboardType:UIKeyboardType = .default
    fileprivate var keyboardReturnType:UIReturnKeyType = .default
    fileprivate var keyboardAppearance:UIKeyboardAppearance = .default
    //fileprivate var rootView:UIView?
    
    fileprivate var placeholderAnimateUp:Bool = false
    
    var discardChars:Array<Character> = []
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var anim:GPAnimation?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    open var text:String? {
        didSet{
            self.gpTextFiled?.text = text
            textfieldValueChanged()
        }
    }
    
    open var characterCount: Int?
    
    //MARK: - Phone
    open var isPhoneType: Bool = false
    var phoneNumberSemaphore: Bool = false
    //MARK: -
    
    func initView() {
        anim = GPAnimation(self)
        //self.background = UIColor.clear
        //self.rootView = UIView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:self.frame.height))
//        self.layoutIfNeeded()
//        self.rootView!.backgroundColor = UIColor.clear
//        self.addSubview(self.rootView!)
        gpTextFiled = UITextField()
        gpTextFiled!.delegate = self
        gpTextFiled!.addTarget(self, action: #selector(textfieldValueChanged), for: UIControlEvents.allEvents)
        gpTextFiled!.borderStyle = self.borderStyle
        gpTextFiled?.translatesAutoresizingMaskIntoConstraints = false
        gpTextFiled!.textColor = self.textColor
        gpTextFiled!.tintColor = self.cursorColor
        gpTextFiled!.font = self.textFont
        
        gpTextFiled!.autocapitalizationType = self.autocapitalizationType
        gpTextFiled!.autocorrectionType = self.autocorrectionType
        gpTextFiled!.spellCheckingType = self.spellCheckingType
        gpTextFiled!.keyboardType = self.keyboardType
        gpTextFiled!.keyboardAppearance = keyboardAppearance
        gpTextFiled!.returnKeyType = self.keyboardReturnType
        
        gpTextFiled!.isUserInteractionEnabled = true
        gpTextFiled!.backgroundColor = self.background
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:16, height:self.gpTextFiled!.frame.height))
        gpTextFiled!.leftView = paddingView
        gpTextFiled!.rightView = paddingView
        gpTextFiled!.leftViewMode = .always

        self.addSubview(gpTextFiled!)
        self.textFieldHeightConst = UIHelper.createHeightConstraint(item: gpTextFiled!, height: self.frame.size.height)
        
        NSLayoutConstraint.activate([UIHelper.createWidthConstraint(item: gpTextFiled!, width: self.frame.size.width),textFieldHeightConst!,UIHelper.createLeadingConstraint(item: gpTextFiled!, toItem: self, constant: 0.0), UIHelper.createTrailingConstraint(item: gpTextFiled!, toItem: self, constant: 0.0), UIHelper.createBottomConstraint(item: gpTextFiled!, toItem: self, constant: 0.0)])
        
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
        
        if extraPlaceholderInfo.characters.count > 0 {
            addplaceholderFormat()
        }
        
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
        NSLayoutConstraint.activate([UIHelper.createIncrecentWidthConstraint(item: errorLabel!, width: 0.0),UIHelper.createHorizontalSpacingConstraint(item: errorLabel!, toItem: !required ? self.placeholderLabel! : placeholderRequiredLabel!, constant: 2.0), UIHelper.createDecrescentTrailingConstraint(item: errorLabel!, toItem: self, constant: 0.0), UIHelper.createTopConstraint(item: errorLabel!, toItem: self.placeholderLabel!, constant: 0.0), UIHelper.createBottomConstraint(item: errorLabel!, toItem: self.placeholderLabel!, constant: 0.0)])
    
    }
    
    func addplaceholderFormat() {
        placeholderFormatLabel = UILabel()
        placeholderFormatLabel!.translatesAutoresizingMaskIntoConstraints = false
        placeholderFormatLabel!.isUserInteractionEnabled = false
        placeholderFormatLabel!.text = extraPlaceholderInfo
        placeholderFormatLabel!.textColor = placeholderColor
        placeholderFormatLabel!.backgroundColor = UIColor.clear
        self.addSubview(placeholderFormatLabel!)
        NSLayoutConstraint.activate([UIHelper.createIncrecentWidthConstraint(item: placeholderFormatLabel!, width: 0.0), UIHelper.createHeightConstraint(item: placeholderFormatLabel!, height: self.frame.size.height),UIHelper.createHorizontalSpacingConstraint(item: placeholderFormatLabel!, toItem: placeholderLabel!, constant: 5.0), UIHelper.createDecrescentTrailingConstraint(item: placeholderFormatLabel!, toItem: self, constant: 0.0), UIHelper.createTopConstraint(item: placeholderFormatLabel!, toItem: self, constant: 0.0)])
    }
    
    //MARK:- UITextField Delegate -
    
    open func getText() -> String? {
        return self.gpTextFiled?.text
    }
    
     public func textfieldValueChanged() {
        print("\(gpTextFiled?.text)")
        if autocapitalizationType == .allCharacters {
            gpTextFiled?.text? = (gpTextFiled?.text?.uppercased())!
        }
        if gpTextFiled?.text?.characters.count == 0 {
            if self.placeholderAnimateUp {
                DispatchQueue.main.async {
                    self.animatePlaceholderDown()
                }
                
            }
            if self.required {
                self.placeholderRequiredLabel?.isHidden = false
            }
        }
        else {
            if !self.placeholderAnimateUp {
                DispatchQueue.main.async {
                    self.animatePlaceholderUp()
                }
            }
            self.placeholderRequiredLabel?.isHidden = true
        }
        
        if self.errorLabel != nil {
            self.errorLabel!.alpha = 0.0
        }
        
        if isPhoneType {
            if phoneNumberSemaphore {return}
            self.phoneNumberSemaphore = true
            self.gpTextFiled?.text = UIHelper.sharedInstance.phoneFormatter.format(phoneNumber: (gpTextFiled?.text)!)
            self.phoneNumberSemaphore = false

        }
        
//        let phoneNumberKit = PhoneNumberKit()
//        phoneNumberKit.countries(withCode: 90)
//        phoneNumberKit.countryCode(for: "TR")
//        gpTextFiled?.text = PartialFormatter.init(phoneNumberKit: phoneNumberKit, defaultRegion: "TR", withPrefix: false).formatPartial(gpTextFiled?.text)
     }

//    func removeFormatAmount(string:String) -> NSNumber {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        formatter.currencySymbol = nil
//        formatter.currencyGroupingSeparator = .none
//        return formatter.number(from: string)!
//    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var input:String = string
        for c in discardChars {
            input = input.replacingOccurrences(of: String(c), with: "")
        }
        
        if (string.characters.count > 0 && input.characters.count == 0 ) || string.characters.count > 1 || (string.characters.count == 1 && self.discardChars.contains(string[string.startIndex])) {
            return false
        }
        
        if let count = characterCount {
            if textField.text!.replacingOccurrences(of: ".", with: "").characters.count == count && string.characters.count != 0 {
                return false
            }
        }
        return true
    }
}

extension GPTextField {
    func animatePlaceholderUp() {
        self.placeholderFormatLabel?.isHidden = true
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
                self.textFieldHeightConst!.constant -= 26
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
                self.textFieldHeightConst!.constant = self.frame.size.height
                if self.placeholderLabel != nil {
                    self.placeholderHeightConst!.constant = self.frame.size.height
                    self.placeholderLabel!.font = self.placeholderFont
                    self.placeholderLabel!.textColor = self.placeholderColor

                }
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.placeholderFormatLabel?.isHidden = false
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
    
    open func gpTextField() -> UITextField {
        return self.gpTextFiled!
    }
    
    open func setPlaceholderText(_ placeholder:String) {
        self.placeholderLabel?.text = placeholder
    }
    
    open func setGPTextColor(_ hexColor:String) {
        self.gpTextFiled!.textColor = UIColor(hex:hexColor)
    }
    
    open func setGPTextFont(_ gpFont:UIFont) {
        self.gpTextFiled!.font = gpFont
    }
    
    open func setGPErrorText(_ errText:String) {
        self.errorLabel!.text = errText
    }
    
    open override func resignFirstResponder() -> Bool {
        self.gpTextFiled?.resignFirstResponder()
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        self.gpTextFiled?.becomeFirstResponder()
        return true
    }
    
    open func discardChars(_ discardChars:Array<Character>) { self.discardChars = discardChars }
    open func autocapitalizationType(_ autocapitalizationType:UITextAutocapitalizationType){ self.gpTextFiled?.autocapitalizationType = autocapitalizationType }
    open func autocorrectionType(_ autocorrectionType:UITextAutocorrectionType){ self.gpTextFiled?.autocorrectionType = autocorrectionType }
    open func spellCheckingType(_ spellCheckingType:UITextSpellCheckingType){ self.gpTextFiled?.spellCheckingType = spellCheckingType }
    open func keyboardType(_ keyboardType:UIKeyboardType){ self.gpTextFiled?.keyboardType = keyboardType }
    open func keyboardReturnType(_ keyboardReturnType:UIReturnKeyType){ self.gpTextFiled?.returnKeyType = keyboardReturnType }
    open func keyboardAppearance(_ keyboardAppearance:UIKeyboardAppearance){ self.gpTextFiled?.keyboardAppearance = keyboardAppearance }
}
