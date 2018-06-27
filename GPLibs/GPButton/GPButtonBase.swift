//
//  GPButtonBase.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 27/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPButtonBase: UIButton {
    
//    @IBInspectable var isLoadingActive:Bool = false
    
    let gradientLeftColor:UIColor = UIColor(hex:"#1219C2")
    let gradientRightColor:UIColor = UIColor(hex:"#10159A")
    let Default_Shadow_Opacity: Float = 0.2
    
    fileprivate var fontName:String?
    fileprivate var fontSize:CGFloat?
    fileprivate var shadowColor:UIColor?
    fileprivate var shadowRadius:CGFloat?
    fileprivate var shadowOffset:CGSize?
    fileprivate var cornerRadius:CGFloat?
    fileprivate var shadowOpacity:Float?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        self.shadowOpacity = Default_Shadow_Opacity
        self.layer.shadowColor = gradientRightColor.cgColor
        self.layer.shadowOpacity = Default_Shadow_Opacity
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.addGradientLayer(leftColor: gradientLeftColor, rightColor: gradientRightColor, size: self.frame.size)
        self.layer.cornerRadius = self.frame.size.height/2                
    }
}

extension GPButtonBase {
    
    func setFont(_ fontName:String, fontSize:CGFloat) {
        self.fontName = fontName
        self.fontSize = fontSize
    }
    
    func setCornerRadius(_ radius:CGFloat) {
        
    }
    
    func setTextColor(_ hexColor:String) {
        
    }
    
    func addGradientLayer(leftColor:UIColor, rightColor:UIColor, size:CGSize) {
        removeGradientLayers()
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        gradientLayer.frame.size = size
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x:1, y:0)
        self.backgroundColor = rightColor
        gradientLayer.colors = [leftColor.cgColor, leftColor.cgColor, rightColor.cgColor, rightColor.cgColor]
        gradientLayer.cornerRadius = self.frame.size.height/2
        self.layer.insertSublayer(gradientLayer, at: 0)        
    }
    
    func setGradientLayerWidth(width:CGFloat, animated:Bool) {
        for l in self.layer.sublayers! {
            if l.isKind(of: CAGradientLayer().classForCoder) {
                if animated {
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                        l.frame.size.width = width
                        self.layoutIfNeeded()
                    }, completion: {
                        (value: Bool) in
                        print("")
                    })
                }
                else {
                    l.frame.size.width = width
                }
                break
            }
        }
    }
    
    func getGradientLayer() -> CALayer? {
        if let layers = self.layer.sublayers {
            for l in layers {
                if l.isKind(of: CAGradientLayer().classForCoder) {
                    return l
                }
            }
        }
        return nil
    }
    
    func removeGradientLayers() {
        guard let gLayer = getGradientLayer() else {
            return
        }
        gLayer.removeFromSuperlayer()
    }
    
    func hideGradientLayer(_ hide:Bool) {
        guard let sublayers = self.layer.sublayers else { return }
        for l in sublayers {
            if l.isKind(of: CAGradientLayer().classForCoder) {
                l.isHidden = hide
                break
            }
        }
    }
    
    func pressed(_ pressed:Bool) {
        if pressed {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98);
            self.layer.shadowOpacity = 0.0
            self.hideGradientLayer(true)
            
        }
        else {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            self.layer.shadowOpacity = self.shadowOpacity!
            self.hideGradientLayer(false)
        }
    }
    
    open func changeShadowLayerProperties(shadowColor: UIColor, shadowOpacity: Float, radius: CGFloat, shadowOffset: CGSize, cornerRadius: CGFloat){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = shadowOffset
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.cornerRadius = cornerRadius
        self.shadowOpacity = shadowOpacity
    }

}
