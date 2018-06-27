//
//  GPLoadingButton.swift
//  GrentaProTest
//
//  Created by Mehmet Cakir on 27/03/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class GPImageButton: GPButtonBase {
        
        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                self.addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
                self.addTarget(self, action: #selector(touchDownAction), for: .touchDown)
                self.addTarget(self, action: #selector(touchOutsideAction), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchOutsideAction), for: .touchDragExit)
        self.addTarget(self, action: #selector(touchDownAction), for: .touchDragEnter)
        
        self.removeGradientLayers()
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
    }    
}
