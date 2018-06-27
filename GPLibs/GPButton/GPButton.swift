//
//  GPLoadingButton.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 27/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPButton: GPButtonBase {
    
//    @IBInspectable var gradientLeft:UIColor? = UIColor.lightGray {
//        didSet {
//        }
//    }
//    @IBInspectable var gradientRight:UIColor? = UIColor.darkGray {
//        didSet {
//            
//        }
//    }        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDownAction), for: .touchDown)
        self.addTarget(self, action: #selector(touchOutsideAction), for: .touchUpOutside)
    }
    
    func touchUpInsideAction() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.pressed(false)
        }, completion: {
            (value: Bool) in
        })
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
     /*
        let gpPopupView1:GPPopupViewController = GPPopupViewController()        
        gpPopupView1.setCancelable(false)
        gpPopupView1.ttt()
        //guard gpPopupView1.show(self, iconImage: "PopupLocationIcon", attributedAlert: true, alert: "Tahmini bakım tarihi aracınızın mevcut kilometresine göre hesaplanmıştır. Ekrandaki oklara (<img width=\"8\" height=\"13\" src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAMAAACJtiw1AAAAQlBMVEUAAAAhIa0RFZoTHaAQFpsQFZsQFpoQFZsQFpsRFpsRFpsRFpsRFpsSF5sSGJ0SFp0TGJwRF5sZIaQTFpsTFpoQFZrcWjDaAAAAFXRSTlMAB+Ua+fLgwerTxqKZZj85NisPUlEZeLWOAAAAcklEQVQY073RSRKAIAwEQFAQ9wWd/39VwLESDl7t21BFQogha01l7/td57YBmlayHZGMcmtGMb95AS1P3hzIbSxILByghNShg9JZ85O6bTqYoEx59iA5lHfFATRE+S+ORofP2R/SaXWAW41yen9J4l4+3BcnC0ov3xVzAAAAAElFTkSuQmCC\">) basılı tutarak aracınızın kilometresini güncelleyebilirsiniz.", button:"AYARLARA GIT", textButton: "VAZGEC") else { return }

   */     
    }
    
    
}
