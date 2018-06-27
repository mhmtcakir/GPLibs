//
//  GPView.swift
//  GPLibs
//
//  Created by Mehmet Cakir on 12/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

open class GPView: UIView {
    
}

extension GPView {
    open func shake() {
        let anim:GPAnimation = GPAnimation(self)
        anim.shake()
    }
}
