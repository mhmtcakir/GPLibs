//
//  GPPopupView.swift
//  GPLibs
//
//  Created by Mehmet Cakir on 05/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit
open class GPPopupView: UIView {
    @IBOutlet weak var blurBackgroundExtraView: UIView!
    @IBOutlet weak var backBlurView: UIVisualEffectView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var mainButton: GPButton!
    @IBOutlet weak var mainButtonHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var textButtonHeightConst: NSLayoutConstraint!
    @IBOutlet weak var editTextField: GPTextField!
    @IBOutlet weak var editTextFieldHeightConst: NSLayoutConstraint!
    @IBOutlet weak var editTextFieldTopConst: NSLayoutConstraint!
    
    private var fontSize:CGFloat = 14.0
    private var fontName:String = "System"
    private var textColor:String = "#9391A8"
    private var isCancelable:Bool = false
    private var viewIsDark = false
    private var rootViewController:UIViewController?
    
    open class func instanceFromNib() -> UIView {
        let mainBundlePath: NSString = Bundle.main.resourcePath! as NSString
        
        let mainURL = URL(fileURLWithPath: mainBundlePath as String)
        
        let frameworkBundlePath = mainURL.appendingPathComponent("Frameworks/GPLibs.framework").path
        
        let frameworkBundle = Bundle(path: frameworkBundlePath)
        
        let popupView: GPPopupView = (UINib(nibName: "GPPopupView", bundle: frameworkBundle).instantiate(withOwner: nil, options: nil)[0] as! UIView as! GPPopupView)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        popupView.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight)
        
        popupView.contentView?.layer.cornerRadius = 10
        popupView.blurBackgroundExtraView?.alpha = 0
        popupView.backBlurView?.alpha = 0
        popupView.contentView?.alpha = 0
        popupView.contentView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        
        return popupView
    }
    
    //MARK:- Init -
    public func setCancelable(_ cancelable:Bool) {
        self.isCancelable = cancelable
    }
    
    func setFontSize(_ fontSize:CGFloat) {
        self.fontSize = fontSize
    }
    
    func setFontName(_ fontName:String) {
        self.fontName = fontName
    }
    
    func setTextColor(_ hexColor:String) {
        self.textColor = hexColor
    }
    
    
    
    func getAttributedString(_ alerttext:String) ->
        NSAttributedString {
            //FIXME: Onur - Font tam olarak uygulanmiyor!!
            let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.fontSize)\"><font color=\(self.textColor)>%@</font></span>" as NSString, alerttext) as String
            
            return try! NSAttributedString(data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            
            
    }
    
    /* func initPopup() {
     rootViewController!.view.addSubview(self.view)
     self.textButton.isHidden = true
     self.textButtonHeightConst.constant = 0
     self.imageView.image = UIImage(named:"PopupHelpIcon")
     let msg = "<span style=\"font-size:14px\" ><font face=\"System\" color=\"#9391A8\">Tahmini bakım tarihi aracınızın mevcut kilometresine göre hesaplanmıştır. Ekrandaki oklara (<img style=\"vertical-align:middle\"  width=\"8\" height=\"13\" src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAMAAACJtiw1AAAAQlBMVEUAAAAhIa0RFZoTHaAQFpsQFZsQFpoQFZsQFpsRFpsRFpsRFpsRFpsSF5sSGJ0SFp0TGJwRF5sZIaQTFpsTFpoQFZrcWjDaAAAAFXRSTlMAB+Ua+fLgwerTxqKZZj85NisPUlEZeLWOAAAAcklEQVQY073RSRKAIAwEQFAQ9wWd/39VwLESDl7t21BFQogha01l7/td57YBmlayHZGMcmtGMb95AS1P3hzIbSxILByghNShg9JZ85O6bTqYoEx59iA5lHfFATRE+S+ORofP2R/SaXWAW41yen9J4l4+3BcnC0ov3xVzAAAAAElFTkSuQmCC\">) basılı tutarak aracınızın kilometresini güncelleyebilirsiniz.</span>"
     
     
     let attrStr = try! NSAttributedString(data: msg.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
     
     
     self.alertLabel.attributedText = attrStr
     }
     */
    //MARK:- Popup Actions -
    open func hide() {
//        makeViewDark()
        (rootViewController as? GPViewController)?.makeViewDark()
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.contentView.alpha = 0
            self.backBlurView.alpha = 0
            self.blurBackgroundExtraView.alpha = 0
            
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
            
        })
    }
    
    public func ttt(){
        print("")
    }
    
    func setPopupView(_ root:UIViewController, iconImage:String?, attributedAlert:Bool, alert:String, button:String?, buttonSelector:Selector?, textButton:String?, textButtonSelector:Selector?) {
        
        rootViewController = root
        rootViewController!.view.addSubview(self)
        (rootViewController as? GPViewController)?.makeViewLight()
        
        guard rootViewController != nil else {
            print("WARNING")
            return
        }
        
        self.alertLabel.font = UIFont(name: self.fontName, size: CGFloat(self.fontSize))
        self.alertLabel.textColor = UIColor(hex:self.textColor)
        self.mainButton.setFont("System", fontSize: 30.0)
        self.mainButton.isHidden = true
        self.mainButtonHeightConst.constant = 0
        self.textButton.isHidden = true
        self.textButtonHeightConst.constant = 0
        //self.mainButton.isLoadingButton = false
        
        self.mainButton.removeTarget(nil, action: nil, for: .allEvents)
        self.textButton.removeTarget(nil, action: nil, for: .allEvents)

        
        if iconImage != nil {
            self.imageView.isHidden = false
            self.imageViewHeightConst.constant = 64
            self.imageView.image = UIImage(named:iconImage!)
        }
        else {
            self.imageView.isHidden = true
            self.imageViewHeightConst.constant = 0
        }
        
        //self.mainButton.removeTarget(nil, action: nil, for: .allEvents)
        //self.textButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if button != nil {
            self.mainButton.setTitle(button, for: .normal)
            self.mainButton.isHidden = false
            self.mainButtonHeightConst.constant = 44
            
            if buttonSelector == nil {
                
                self.mainButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            }
            else {
                self.mainButton.addTarget(self.rootViewController, action: buttonSelector!, for: .touchUpInside)
            }
        }
        
        if textButton != nil {
            self.textButton.setTitle(textButton, for: .normal)
            self.textButton.isHidden = false
            self.textButtonHeightConst.constant = 44
            
            if textButtonSelector == nil {
                
                self.textButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            }
            else {
                self.textButton.addTarget(self.rootViewController, action: textButtonSelector!, for: .touchUpInside)
            }
        }
        
        if attributedAlert {
            self.alertLabel.attributedText = getAttributedString(alert)
        }
        else {
            self.alertLabel.text = alert
        }
        
        //        makeViewLight()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.blurBackgroundExtraView?.alpha = 0.4
            self.backBlurView.alpha = 1.0
        }, completion: {
            (value: Bool) in
            print("")
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.7,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        
                        self?.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self?.contentView.alpha = 1.0
                        
            },
                       completion:{ (finished: Bool) in
                        print("")
                        
        })

        
    }
    
    open func showInputPopup(_ root:UIViewController,placeholder:String, iconImage:String?, attributedAlert:Bool, alert:String!, button:String?, buttonSelector:Selector?, textButton:String?, textButtonSelector:Selector?) {
        
        editTextField.gpTextField().text?.removeAll()
        editTextField.setGPErrorText("En az XYZ km")
        editTextField.setGPTextFont(UIFont.systemFont(ofSize: 19, weight: UIFontWeightMedium))
        editTextField.setGPTextColor("#373744")
        editTextField.setPlaceholderText(placeholder)
        editTextFieldTopConst.constant = 24
        editTextFieldHeightConst.constant = 57
        editTextField.isHidden = false        
        
        setPopupView(root, iconImage: iconImage, attributedAlert: attributedAlert, alert: alert, button: button, buttonSelector: buttonSelector, textButton: textButton, textButtonSelector: textButtonSelector)
        

        //FIXME MC: !!!! Bu neden burada. Ben kaldirdim. Ctrl
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.editTextField.showError()
//        }
        
    }
    
    open func show(_ root:UIViewController, iconImage:String?, attributedAlert:Bool, alert:String!, button:String?, buttonSelector:Selector?, textButton:String?, textButtonSelector:Selector?) {
        
        editTextFieldTopConst.constant = 0
        editTextFieldHeightConst.constant = 0
        editTextField.isHidden = true
        
        setPopupView(root, iconImage: iconImage, attributedAlert: attributedAlert, alert: alert, button: button, buttonSelector: buttonSelector, textButton: textButton, textButtonSelector: textButtonSelector)                
        
    }
    
    @IBAction func touchToCancelButtonAction(_ sender: UIButton) {
        if isCancelable {
            hide()            
        }
    }
    
    open func gpTextFieldErrorOccured() {
        self.editTextField.shake()        
    }
    
    
//    func makeViewDark() {
//        UIApplication.shared.statusBarStyle = .default
//        viewIsDark = true
//        setNeedsStatusBarAppearanceUpdate()
//    }
//    
//    func makeViewLight() {
//        UIApplication.shared.statusBarStyle = .lightContent
//        viewIsDark = false
//        setNeedsStatusBarAppearanceUpdate()
//    }
    
//    override public var preferredStatusBarStyle: UIStatusBarStyle {
//        
//        if !viewIsDark {
//            return .lightContent
//        } else {
//            return .default
//        }
//    }
    
    
    //MARK:- Button Actions -
    
    @IBAction func dismissAction(_ sender: Any) {
        hide()
    }
    
}
