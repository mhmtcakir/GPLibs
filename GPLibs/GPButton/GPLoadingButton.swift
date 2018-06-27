//
//  GPLoadingButton.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 27/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPLoadingButton: GPButtonBase {
    
//    @IBInspectable var gradientLeft:UIColor? = UIColor.lightGray {
//        didSet {
//        }
//    }
//    @IBInspectable var gradientRight:UIColor? = UIColor.darkGray {
//        didSet {
//            
//        }
//    }
    
    var buttonLoadingIndicator:CustomActivityIndicatorView?
    var widthConst:NSLayoutConstraint?
    var buttonWidth:CGFloat!
    open var isLoadingActive:Bool = false
    open var showLoading:Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLoadingView()
    }
    
    func initLoadingView() {
        buttonLoadingIndicator = CustomActivityIndicatorView()
        buttonLoadingIndicator?.frame.size.width = 22
        buttonLoadingIndicator?.frame.size.height = 22
        buttonLoadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        let mainBundlePath: NSString = Bundle.main.resourcePath! as NSString
        let mainURL = URL(fileURLWithPath: mainBundlePath as String)
        let frameworkBundlePath = mainURL.appendingPathComponent("Frameworks/GPLibs.framework").path
        let frameworkBundle = Bundle(path: frameworkBundlePath)
        
        buttonLoadingIndicator?.indicatorImage = UIImage(named: "LoadingIndicator", in: frameworkBundle, compatibleWith: nil)
        buttonLoadingIndicator!.isHidden = false
        buttonLoadingIndicator?.alpha = 0
        self.addSubview(buttonLoadingIndicator!)
        for constraint in self.constraints {
            if (constraint.firstAttribute == NSLayoutAttribute.width) {
                self.widthConst = constraint
                break
            }
        }
        buttonLoadingIndicator!.isUserInteractionEnabled = false
        buttonLoadingIndicator!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([UIHelper.createWidthConstraint(item: buttonLoadingIndicator!, width: 22.0), UIHelper.createHeightConstraint(item: buttonLoadingIndicator!, height: 22.0), UIHelper.createCenterHorizontalConstraint(item: buttonLoadingIndicator!, toItem: self, constant: 0.0), UIHelper.createCenterVerticalConstraint(item: buttonLoadingIndicator!, toItem: self, constant: 0.0)])              
        
        self.addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDownAction), for: .touchDown)
        self.addTarget(self, action: #selector(touchOutsideAction), for: .touchUpOutside)
        
        buttonWidth = self.frame.size.width

    }
    
    open func stopLoadingTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.addGradientLayer(leftColor: UIColor(hex:"1219C2"), rightColor: UIColor(hex:"10159A"), size: CGSize(width: 0, height: self.frame.size.height))
            
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.layer.shadowRadius = 20
                self.layer.shadowOpacity = 0.25
                self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
                self.buttonLoadingIndicator!.alpha = 0.0
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                print("")
                self.setGradientLayerWidth(width: 160.0, animated: true)
            })
            
            self.widthConst!.constant = self.buttonWidth
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                print("")
            })
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.titleLabel!.alpha = 1.0
                self.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                print("")
            })
            
            self.isLoadingActive = false
        }
    }
    
    open func startLoadingButtonTransition() {
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.titleLabel!.alpha = 0
            self.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            print("")
        })
        
        self.widthConst!.constant = self.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.buttonLoadingIndicator!.alpha = 1.0
            self.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            print("")
        })
        
        UIView.animate(withDuration: 0.15, delay: 0.1, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.layer.sublayers?[0].frame.size.width = self.frame.size.height            
            self.addGradientLayer(leftColor: UIColor(hex:"10159A"), rightColor: UIColor(hex:"10159A"), size: CGSize(width: self.frame.size.height, height: self.frame.size.height))
            self.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            print("")
        })
    }
    
    func touchUpInsideAction() {
        if !isLoadingActive {
            for sv in self.subviews {
                if sv.isKind(of: CustomActivityIndicatorView().classForCoder) {
                    (sv as! CustomActivityIndicatorView).startAnimating()
                }
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.pressed(false)
            }, completion: {
                (value: Bool) in
                if self.showLoading {
                    self.startLoadingButtonTransition()
                }
            })
            isLoadingActive = true
            //FIXME: MC ?? isloading active flagi nerede olmali?
            //FIXME: Onur - Flag yuzunden loading gorunmuyor!
        }
        else {
            //if showLoading {
                self.stopLoadingTransition()
            //}
            //self.stopLoadingTransition()
        }
    }
    
    func touchDownAction() {
        UIView.animate(withDuration: 0.05, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.pressed(true)
        }, completion: {
            (value: Bool) in
            print("")
        })
    }
    
    func touchOutsideAction() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.pressed(false)
        }, completion: {
            (value: Bool) in
            print("")
        })
    }
    
    open func showLoading(_ showLoading:Bool) {
        self.showLoading = showLoading
    }
}
