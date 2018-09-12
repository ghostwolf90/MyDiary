//
//  RLM_User.swift
//  Coffee Luguo
//
//  Created by Laibit on 2018/9/4.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RLM_User: Object {
    
    @objc dynamic var id:String = UUID().uuidString.lowercased() // RLM id
    @objc dynamic var userid:String     = "" //Facebook ID
    @objc dynamic var name:String       = ""
    @objc dynamic var picture:String    = ""
    @objc dynamic var email:String      = ""
    @objc dynamic var creatTime:Int     = 0
    @objc dynamic var loginTime:Int     = 0
    
    //設置索引主鍵
    override static func primaryKey() -> String {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    required convenience init?(user:RLM_User) {
        self.init()
        userid      = user.id
        name        = user.name
        picture     = user.picture
        email       = user.email
        creatTime   = user.creatTime
        loginTime   = user.loginTime
        
    }
}

// MARK: RLM_UserUtil Data操作相關
struct RLM_UserUtil{
    static var sharedInstance = RLM_UserUtil()
    let realm = try! Realm()
    
    ///儲存使用者
    func addUser(user: RLM_User, completion:((Bool)->())){
        guard let user = RLM_User(user: user) else{
            completion(false)
            return
        }
        
        do{
            try realm.write(
                transactionBlock: {
                    realm.add(user, update: true)
            },completion: {
                    completion(true)
            })
        }catch let error {
            //CrashReport.log(error.localizedDescription)
            //CrashReport.log("\(user.userid) 存入DB失敗")
            print("\(user.userid) 存入DB失敗 原因\(error.localizedDescription)")
            completion(false)
        }
    }
    
    ///清除使用者
    func deleteUser(){
        if let user = realm.objects(RLM_User.self).first {
            try! realm.write {
                realm.delete(user)
            }
        }
    }
    
    ///取得使用者登入資料
    func getUser() -> RLM_User{
        let user = realm.objects(RLM_User.self)
        guard user.count > 0 else {
            return RLM_User()
        }
        return user.first!
    }
    
}
