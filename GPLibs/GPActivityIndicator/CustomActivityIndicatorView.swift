//
//  CustomActivityIndicatorView.swift
//  CustomIndicator
//
//  Created by hsusmita on 10/08/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit

 public class CustomActivityIndicatorView: UIView {

  var hidesWhenStopped: Bool
  var isAnimating: Bool
  fileprivate var animationLayer: CALayer
  
  @IBInspectable var indicatorImage:UIImage? {
    didSet {
      configureAnimationLayer(indicatorImage!)
    }
  }
  
  convenience init(image:UIImage,frame:CGRect) {
    self.init(frame:frame)
    indicatorImage = image
    configureAnimationLayer(image)
  }
  
  required public init(coder aDecoder: NSCoder) {
    hidesWhenStopped = false
    isAnimating = false
    animationLayer = CALayer()
    super.init(coder: aDecoder)!
  }
  
   override init(frame: CGRect) {
    hidesWhenStopped = false
    isAnimating = false
    animationLayer = CALayer()
    super.init(frame: frame)
  }
  
  func startAnimating() {
    if animationLayer.animation(forKey: "rotation") == nil {
      animationLayer.add(rotationAnimation(), forKey: "rotation")
    }
    
    if self.hidesWhenStopped {
      self.isHidden = false
    }
    resumeLayer()
    isAnimating = true;
  }
  
  func stopAnimating() {
    if self.hidesWhenStopped {
      self.isHidden = true
    }
    pauseLayer()
    isAnimating = false
  }
  
  fileprivate func configureAnimationLayer(_ indicatorImage:UIImage) {
    animationLayer.frame = CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height)
    animationLayer.contents = indicatorImage.cgImage
    animationLayer.masksToBounds = true
    layer.addSublayer(animationLayer)
    self.isHidden = true
  }
  
  fileprivate func rotationAnimation()-> CABasicAnimation {
    let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotation.duration = 1.0
    rotation.isRemovedOnCompletion = false;
    rotation.repeatCount = Float.infinity
    rotation.fillMode = kCAFillModeForwards;
    rotation.fromValue = 0.0
    rotation.toValue = M_PI * 2;
    return rotation
  }
  
  fileprivate func pauseLayer() {
    let pausedTime = animationLayer.convertTime(CACurrentMediaTime(), from: nil)
    animationLayer.speed = 0.0
    animationLayer.timeOffset = pausedTime
  }
  
  fileprivate func resumeLayer() {
    let pauseTime = animationLayer.timeOffset
    animationLayer.speed = 1.0
    animationLayer.timeOffset = 0.0
    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
    animationLayer.beginTime = timeSincePause
  }
  
}
