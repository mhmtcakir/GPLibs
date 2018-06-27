//
//  GPSegmentedControl.swift
//  GPLibs
//
//  Created by Onur ILGAZ on 20/07/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

@IBDesignable
open class GPSegmentedControl: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!
    public var selectedSegmentIndex = 0
    
    @IBInspectable
    public var seperatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var disableTextColor: UIColor = UIColor(hex: "BFBEC6") {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var disableBackgroundColor: UIColor = UIColor(hex: "F5F4F8") {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = UIColor(hex: "1319C1") {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    public func setButtonEnable(_ buttonIndex:Int) {
        if buttonIndex >= 0 && buttonIndex < buttons.count {
            buttons[buttonIndex].isEnabled = true
        }
    }
    public func setButtonDisable(_ buttonIndex:Int) {
        if buttonIndex >= 0 && buttonIndex < buttons.count {
            buttons[buttonIndex].isEnabled = false
        }
    }
    
    //FIXME MC: Konrol edilecek !! her islemde tum butonlar silinip tekrar ekleniyor.
    func updateView() {
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let borderView = UIView()
        borderView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        borderView.layer.cornerRadius = borderView.frame.height/2
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor(hex: "D7D6DD").cgColor
        addSubview(borderView)
        let buttonTitles = seperatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: UIFontWeightMedium)
            button.setTitleColor(textColor, for: .normal)
            button.setTitleColor(disableTextColor, for: .disabled)
            button.setBackgroundColor(color: disableBackgroundColor, forState: .disabled)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.backgroundColor = selectorColor
        let rectShape = CAShapeLayer()
        rectShape.bounds = selector.frame
        rectShape.position = selector.center
        rectShape.path = UIBezierPath(roundedRect: selector.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: selector.frame.height/2, height: selector.frame.height/2)).cgPath
        selector.layer.mask = rectShape
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    override open func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
        updateView()
    }
    
    func buttonTapped(button: UIButton) {
        for (buttonIndex, bttn) in buttons.enumerated() {
            bttn.setTitleColor(textColor, for: .normal)
            
            if bttn == button {
                selectedSegmentIndex = buttonIndex
                setSegmentButtonSelected(buttonIndex)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    public func setSegmentButtonSelected(_ buttonIndex:Int) {
        let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
        selector.frame.origin.x = selectorStartPosition
        let tappedButton = buttons[buttonIndex]
        tappedButton.setTitleColor(selectorTextColor, for: .normal)
        let rectShape = CAShapeLayer()
        rectShape.bounds = selector.frame
        rectShape.position = selector.center
        if buttonIndex == 0 {
            rectShape.path = UIBezierPath(roundedRect: selector.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: selector.frame.height/2, height: selector.frame.height/2)).cgPath
        } else if buttonIndex == buttons.count - 1 {
            rectShape.path = UIBezierPath(roundedRect: selector.bounds, byRoundingCorners: [.bottomRight , .topRight], cornerRadii: CGSize(width: selector.frame.height/2, height: selector.frame.height/2)).cgPath
        } else {
            rectShape.path = UIBezierPath(roundedRect: selector.bounds, byRoundingCorners: [.bottomLeft , .topLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: 0, height: 0)).cgPath
        }
        selector.layer.mask = rectShape
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
