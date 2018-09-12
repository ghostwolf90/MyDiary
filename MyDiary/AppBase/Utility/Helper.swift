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
}
