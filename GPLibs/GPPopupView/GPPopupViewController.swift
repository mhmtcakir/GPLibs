//
//  NewGPPopupViewController.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 30/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPPopupViewController: UIViewController {
    
    @IBOutlet weak var backBlurView: UIVisualEffectView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var alertLabel: UILabel!    
    @IBOutlet weak var mainButton: GPButton!
    @IBOutlet weak var mainButtonHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var textButtonHeightConst: NSLayoutConstraint!        
    
    private var fontSize:CGFloat = 14.0
    private var fontName:String = "System"
    private var textColor:String = "#9391A8"
    private var isCancelable:Bool = false
    private var viewIsDark = false
    private var rootViewController:UIViewController?
    //MARK:- Override - 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        self.contentView?.layer.cornerRadius = 10
        self.backBlurView?.alpha = 0
        self.contentView?.alpha = 0
        self.contentView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        
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
            let msg = "<span style=\"font-size:\(self.fontSize)px\" ><font face=\(self.fontName) color=\(self.textColor)>\(alerttext)</span>"
            
            return try! NSAttributedString(data: msg.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
        
    }
    
   /* func initPopup() {
        rootViewController!.view.addSubview(self.view)
        self.textButton.isHidden = true
        self.textButtonHeightConst.constant = 0
        self.imageView.image = UIImage(named:"PopupHelpIcon")
        let msg = "<span style=\"font-size:14px\" ><font face=\"System\" color=\"#9391A8\">Tahmini bakım tarihi aracınızın mevcut kilometresine göre hesaplanmıştır. Ekrandaki oklara (<img width=\"8\" height=\"13\" src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAMAAACJtiw1AAAAQlBMVEUAAAAhIa0RFZoTHaAQFpsQFZsQFpoQFZsQFpsRFpsRFpsRFpsRFpsSF5sSGJ0SFp0TGJwRF5sZIaQTFpsTFpoQFZrcWjDaAAAAFXRSTlMAB+Ua+fLgwerTxqKZZj85NisPUlEZeLWOAAAAcklEQVQY073RSRKAIAwEQFAQ9wWd/39VwLESDl7t21BFQogha01l7/td57YBmlayHZGMcmtGMb95AS1P3hzIbSxILByghNShg9JZ85O6bTqYoEx59iA5lHfFATRE+S+ORofP2R/SaXWAW41yen9J4l4+3BcnC0ov3xVzAAAAAElFTkSuQmCC\">) basılı tutarak aracınızın kilometresini güncelleyebilirsiniz.</span>"
        
        
        let attrStr = try! NSAttributedString(data: msg.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        
        
        self.alertLabel.attributedText = attrStr
    }
    */
    //MARK:- Popup Actions -
    func hide() {
        makeViewDark()
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.contentView.alpha = 0
            self.backBlurView.alpha = 0
            
        }, completion: {
            (value: Bool) in
            self.view.removeFromSuperview()
            
        })
    }
    
    public func ttt(){
        print("")
    }
    
    public func show(_ root:UIViewController, iconImage:String?, attributedAlert:Bool, alert:String!, button:String?, textButton:String?) -> Bool {
        rootViewController = root
        rootViewController!.view.addSubview(self.view)
        
        guard rootViewController != nil else {
            print("WARNING")
            return false
        }
        
        self.alertLabel.font = UIFont(name: self.fontName, size: CGFloat(self.fontSize))
        self.alertLabel.textColor = UIColor(hex:self.textColor)
        self.mainButton.setFont("System", fontSize: 30.0)
        self.mainButton.isHidden = true
        self.mainButtonHeightConst.constant = 0
        self.textButton.isHidden = true
        self.textButtonHeightConst.constant = 0
        //self.mainButton.isLoadingButton = false
        
        
        if iconImage != nil {
            self.imageView.isHidden = false
            self.imageViewHeightConst.constant = 64
            self.imageView.image = UIImage(named:iconImage!)
        }
        else {
            self.imageView.isHidden = true
            self.imageViewHeightConst.constant = 0
        }
        
        if button != nil {
            self.mainButton.setTitle(button, for: .normal)
            self.mainButton.isHidden = false
            self.mainButtonHeightConst.constant = 44
        }
        
        if textButton != nil {
            self.textButton.setTitle(textButton, for: .normal)
            self.textButton.isHidden = false
            self.textButtonHeightConst.constant = 44
        }
        
        if attributedAlert {
            self.alertLabel.attributedText = getAttributedString(alert)
        }
        else {
            self.alertLabel.text = alert
        }
        
        makeViewLight()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.backBlurView.alpha = 1.0
        }, completion: {
            (value: Bool) in
            print("")
        })
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 5.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        
                        self?.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self?.contentView.alpha = 1.0
                        
            },
                       completion:{ (finished: Bool) in
                        print("")
                        
        })
        
        return true

    }
    
    @IBAction func touchToCancelButtonAction(_ sender: Any) {
        if isCancelable {
            hide()
        }
    }
    
    
    func makeViewDark() {
        UIApplication.shared.statusBarStyle = .default
        viewIsDark = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func makeViewLight() {
        UIApplication.shared.statusBarStyle = .lightContent
        viewIsDark = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        
        if !viewIsDark {            
            return .lightContent
        } else {
            return .default
        }
    }
    

    //MARK:- Button Actions -
    
    @IBAction func dismissAction(_ sender: Any) {        
        hide()
    }
    
    
}
