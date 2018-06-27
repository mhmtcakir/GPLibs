//
//  UIHelper.swift
//  GPLib
//
//  Created by Mehmet Cakir on 03/04/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

public class UIHelper {
    var phoneFormatter = PhoneNumberFormatter()
    static let sharedInstance: UIHelper = {
        let instance = UIHelper()
        instance.phoneFormatter.defaultLocale = "tr"
        return instance
    }()
    
    public static func createIncrecentWidthConstraint(item:Any, width:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .width, relatedBy: .greaterThanOrEqual, toItem: nil,
                    attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                    constant: width)
    }
    
    public static func createDecrescentWidthConstraint(item:Any, width:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .width, relatedBy: .lessThanOrEqual, toItem: nil,
                    attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                    constant: width)
    }
    
    public static func createWidthConstraint(item:Any, width:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .width, relatedBy: .equal, toItem: nil,
                    attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                    constant: width)
    }
    
    public static func createIncrecentHeightConstraint(item:Any, height:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .height, relatedBy: .greaterThanOrEqual, toItem: nil,
                     attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                     constant: height)
    }
    
    public static func createDecrescentHeightConstraint(item:Any, height:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .height, relatedBy: .lessThanOrEqual, toItem: nil,
                     attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                     constant: height)
    }
    
    public static func createHeightConstraint(item:Any, height:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute:
            .height, relatedBy: .equal, toItem: nil,
                     attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0,
                     constant: height)
    }
    
    public static func createCenterHorizontalConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    }
    
    public static func createCenterVerticalConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    }
    
    public static func createLeadingConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: constant)
    }
    
    public static func createIncrecentTrailingConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: toItem, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
    }
    
    public static func createDecrescentTrailingConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: toItem, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
    }
    
    public static func createTrailingConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
    }
    
    public static func createTopConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.top, multiplier: 1, constant: constant)
    }
    
    public static func createBottomConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constant)
    }
    
    public static func createHorizontalSpacingConstraint(item:Any, toItem:Any, constant:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: toItem, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant)
    }
    
    
}
