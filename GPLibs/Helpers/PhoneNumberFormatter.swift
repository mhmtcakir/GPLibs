//
//  PhoneNumberFormatter.swift
//  GarentaPro
//
//  Created by Burak SIPCIKOGLU on 07/08/2017.
//  Copyright © 2017 Mehmet Cakir. All rights reserved.
//

import UIKit

open class PhoneNumberFormatter: NSObject {

    var predefinedFormats: NSDictionary?
    var defaultLocale: String?
    
    
    convenience override init() {
        let usPhoneFormats = NSArray(objects: "+1 (###) ###-####"
            , "1 (###) ###-####"
            , "011 $", "###-####"
            , "(###) ###-####")
        
        let trPhoneFormats = NSArray(objects: "#### ### ## ##")

        let ukPhoneFormats = NSArray(objects: "####-####-####-####")

        let jpPhoneFormats = NSArray(objects: "+81 ############"
            , "001 $"
            , "(0#) #######"
            , "(0#) #### ####")
    
        self.init(dict: NSDictionary(dictionary: ["us" : usPhoneFormats
            , "tr" : trPhoneFormats
            , "uk" : ukPhoneFormats
            , "jp" : jpPhoneFormats]))
    }
    
    init(dict: NSDictionary) {
        self.predefinedFormats = NSDictionary(dictionary: dict)
    }
    
    func format(phoneNumber: String, withLocale locale: String) -> String {
        guard let localeFormats = predefinedFormats?.object(forKey: locale) as? [String] else {return phoneNumber}
        let input = strip(phoneNumber: phoneNumber)
        for phoneFormat in localeFormats {
            var i = 0
            var temp: NSMutableString? = ""
            var phoneFormatCharacters = getCharacterSet(string: phoneFormat)
            var inputCharacters = getCharacterSet(string: input)
            for var index in 0...phoneFormat.characters.count where temp != nil && i < input.characters.count {
                let c = phoneFormatCharacters[index]
                let required = canBeInputByPhonePad(c: c)
                let next = inputCharacters[i]
                switch c {
                case "$":
                    index -= 1
                    temp?.appendFormat("%@", next)
                    i += 1
                    break
                case "#":
                    if Int(next)! < 0 || Int(next)! > 9 {
                        temp = nil
                        break
                    }
                    temp?.appendFormat("%@", next)
                    i += 1
                    break
                default:
                    if required {
                        if next != c {
                            temp = nil
                            break
                        }
                        temp?.appendFormat("%@", next)
                        i += 1
                    }else {
                        temp?.appendFormat("%@", c)
                        if next == c {i += 1}
                    }
                    break
                }
            }
            if i ==  input.characters.count {
                return temp! as String
            }
        }
        return input
    }
    
    func format(phoneNumber: String) -> String {
        return format(phoneNumber: phoneNumber, withLocale: defaultLocale!)
    }
    
    func strip(phoneNumber: String) -> String {
        let res: NSMutableString! = ""
        
        var characters = [String]()
        for element in phoneNumber.characters {
            characters.append((String(element)))
        }
        for item in characters {
            if canBeInputByPhonePad(c: item) {
                res.append(item)
            }
        }
        return res as String
    }
    
    func canBeInputByPhonePad(c: String) -> Bool{
        return c == "+" || c == "*" || c == "#" || Int(c) ?? -1 >= 0 || Int(c) ?? 10 <= 9
    }
    
    func getCharacterSet(string: String) -> [String] {
        var set = [String]()
        for element in string.characters {
            set.append((String(element)))
        }
        return set
    }
    
}
