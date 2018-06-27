//
//  GPViewController.swift
//  GPLibs
//
//  Created by Mehmet Cakir on 05/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

open class GPViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    open var topShadow:UIImageView?
    open var navigationBarHidden = true
    open var disableSwipeToBack: Bool = false
    open var gpPopupView : GPPopupViewController?
    open var comingFromBackground: Bool = false
//    open var gpPopupVi : GPPopupView?
    
    private var viewIsDark = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundNotificationReceived), name: NSNotification.Name(rawValue: "ComesFromBackgroundNotification"), object: nil)
        
//        gpPopupVi = GPPopupView.instanceFromNib() as! GPPopupView

        
        
        //        self.view.addSubview(gpPopupVi!)
        
        
        
        //let gpview:GPPopupView = GPPopupView.instanceFromNib() as! GPPopupView
        //self.gpPopupView = GPPopupViewController(nibName: "GPPopupViewController", bundle: nil)
        
       // let rt:GPPopupViewController = (UINib(nibName: "GPPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GPPopupViewController)
        
        //print("")
        //self.view.addSubview(gpview)
        //self.gpPopupView?.setCancelable(false)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !navigationBarHidden && topShadow == nil {
            addNavigationBarShadow()
        }
        
        if disableSwipeToBack {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        else{
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.topShadow != nil {
            self.view.bringSubview(toFront: topShadow!)
        }
    }
    
    open func showPopup() {
        self.present(self.gpPopupView!, animated: true, completion: nil)
       // guard (self.gpPopupView?.show(self, iconImage: "PopupLocationIcon", attributedAlert: true, alert: "Tahmini bakım tarihi aracınızın mevcut kilometresine göre hesaplanmıştır. Ekrandaki oklara (<img width=\"8\" height=\"13\" src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAMAAACJtiw1AAAAQlBMVEUAAAAhIa0RFZoTHaAQFpsQFZsQFpoQFZsQFpsRFpsRFpsRFpsRFpsSF5sSGJ0SFp0TGJwRF5sZIaQTFpsTFpoQFZrcWjDaAAAAFXRSTlMAB+Ua+fLgwerTxqKZZj85NisPUlEZeLWOAAAAcklEQVQY073RSRKAIAwEQFAQ9wWd/39VwLESDl7t21BFQogha01l7/td57YBmlayHZGMcmtGMb95AS1P3hzIbSxILByghNShg9JZ85O6bTqYoEx59iA5lHfFATRE+S+ORofP2R/SaXWAW41yen9J4l4+3BcnC0ov3xVzAAAAAElFTkSuQmCC\">) basılı tutarak aracınızın kilometresini güncelleyebilirsiniz.", button:"AYARLARA GIT", textButton: "VAZGEC"))! else { return }
    }
    
    
    //MARK:- ScrollView Delegate -
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset)")
        if self.topShadow != nil {
            if scrollView.contentOffset.y > 15 {
                self.topShadow!.alpha = scrollView.contentOffset.y/45
            }
            else {
                self.topShadow!.alpha = 0.0
            }
        }
    }
    
    //MARK:- UIGestureRecognizerDelegate -
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return true
        }
        return false
    }

    
    private func addNavigationBarShadow() {
        topShadow = UIImageView(image: UIImage(named:"NavigationBarTopShadow"))
        topShadow!.alpha = 0.0
        topShadow!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topShadow!)
        
        NSLayoutConstraint.activate([UIHelper.createLeadingConstraint(item: topShadow!, toItem: self.view, constant: 0.0),UIHelper.createTrailingConstraint(item: topShadow!, toItem: self.view, constant: 0.0),UIHelper.createTopConstraint(item: topShadow!, toItem: self.view, constant: 64.0),UIHelper.createHeightConstraint(item: topShadow!, height: 23.0)])
    }

    @IBAction func backButtonAction1(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    open func makeViewDark() {
        UIApplication.shared.statusBarStyle = .default
        viewIsDark = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open func makeViewLight() {
        UIApplication.shared.statusBarStyle = .lightContent
        viewIsDark = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        
        if !viewIsDark {
            return .lightContent
        } else {
            return .default
        }
    }
    
    open func refreshView() {
        
    }
    
    func backgroundNotificationReceived() {
        comingFromBackground = true
        self.refreshView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
