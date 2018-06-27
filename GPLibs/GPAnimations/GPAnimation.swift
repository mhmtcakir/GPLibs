//
//  GPAnimation.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 31/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPAnimation {
    
    fileprivate var view:UIView?
    
    init(_ view:UIView) {
        self.view = view
    }
    
    public func shake() {
        UIView.animate(withDuration: 0.012, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x += 0.00001
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            self.shakeFirstAction()
        })
    }
    
    fileprivate func shakeFirstAction() {
        UIView.animate(withDuration: 0.108, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x += 9.99999
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            self.shakeSecondAction()
        })
    }
    
    fileprivate func shakeSecondAction() {
        UIView.animate(withDuration: 0.12, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x -= 16
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            self.shakeThirdAction()
        })
    }
    
    fileprivate func shakeThirdAction() {
        UIView.animate(withDuration: 0.12, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x += 8
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            self.shakeFourthAction()
        })
    }
    
    fileprivate func shakeFourthAction() {
        UIView.animate(withDuration: 0.12, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x -= 4
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            self.shakeFifthAction()
        })
    }
    
    fileprivate func shakeFifthAction() {
        UIView.animate(withDuration: 0.12, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view!.frame.origin.x += 2
            self.view!.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            print("")
        })
    }

    
}
