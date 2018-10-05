//
//  Helper.swift
//  Coffee Luguo
//
//  Created by Laibit on 2018/9/5.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit

struct Helper {
    
    static var homepage: UIViewController? {
        let board: UIStoryboard!
        board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewController(withIdentifier: "IndexViewController")
    }
    
    static var login: UIViewController? {
        let board: UIStoryboard!
        board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewController(withIdentifier: "LoginViewController")
    }
    
    static func backToLogin(){
        Helper.revealVC(viewController: Helper.login!)
    }
    
    static func toHome(){
        Helper.revealVC(viewController: Helper.homepage!)
    }
    
    static func revealVC(viewController:UIViewController){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = viewController
    }
    
    static var rocYear: String {
        get {
            let calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
            let component = (calendar as NSCalendar?)?.components([.year], from: Date())
            let year = component?.year
            return String(year!)
        }
    }
    
    static func receiptDuration(_ time: Date = Date() ) -> String {
        let calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        let component = (calendar as NSCalendar?)?.components([.month], from: time)
        let month = component!.month!
        let isOddMonth = month%2==1
        let firstMonth = isOddMonth ? month:month-1
        let secondMonth = isOddMonth ? month+1:month
        let s = NSString(format: "%02d-%02d", firstMonth,secondMonth) as String
        return s
    }
    
    static func generateNowTimes() -> (String, String, String, String, String){
        let currentdate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY"
        let year = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "MMMM"
        let month = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "dd"
        let day = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "EEEE"
        let week = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "HH:mm:ss"
        let hms = dateformatter.string(from: currentdate)
        return (year, month, day, week, hms)
    }
    
    static func generateNowTime() -> String{
        let currentdate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY"
        let year = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "MM-dd"
        let month = dateformatter.string(from: currentdate)
        dateformatter.dateFormat = "HH:mm:ss"
        let hms = dateformatter.string(from: currentdate)
        return year  + "-" + month + " " + hms
    }
}
