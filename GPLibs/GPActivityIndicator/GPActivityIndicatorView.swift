//
//  GPActivityIndicatorView.swift
//  GPLibs
//
//  Created by Mehmet Cakir on 20/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

open class GPActivityIndicatorView: UIView {
    
    @IBOutlet weak var loadingIndicator: CustomActivityIndicatorView!
    
    private var rootViewController:UIViewController?
    
    open class func instanceFromNib() -> UIView {
        let mainBundlePath: NSString = Bundle.main.resourcePath! as NSString
        
        let mainURL = URL(fileURLWithPath: mainBundlePath as String)
        
        let frameworkBundlePath = mainURL.appendingPathComponent("Frameworks/GPLibs.framework").path
        
        let frameworkBundle = Bundle(path: frameworkBundlePath)
        
        let popupView: GPActivityIndicatorView = (UINib(nibName: "GPActivityIndicatorView", bundle: frameworkBundle).instantiate(withOwner: nil, options: nil)[0] as! UIView as! GPActivityIndicatorView)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        popupView.backgroundColor = UIColor.clear
        popupView.frame = CGRect(x:0, y:64.0, width:screenWidth, height:screenHeight-64.0)
//        popupView.frame = CGRect(x:(screenWidth/2)-11, y:(screenHeight/2)-11, width:22, height:22)
        popupView.loadingIndicator.indicatorImage = UIImage(named: "ActivityIndicator", in: frameworkBundle, compatibleWith: nil)
        
        return popupView
    }
    
    open func show(_ root:UIViewController) {
        self.loadingIndicator.hidesWhenStopped = true
        rootViewController = root
        
        guard rootViewController != nil else {
            print("WARNING")
            return
        }
        
        rootViewController!.view.addSubview(self)
        self.loadingIndicator.startAnimating()
    }
    
    open func hide() {
        self.loadingIndicator.stopAnimating()
        self.removeFromSuperview()
    }
    
}
