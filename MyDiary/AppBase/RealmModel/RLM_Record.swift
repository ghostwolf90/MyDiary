//
//  RLM_Record.swift
//  Coffee Luguo
//
//  Created by Laibit on 2018/9/7.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class RLM_Record: Object {
    
    @objc dynamic var id:String = UUID().uuidString.lowercased() // RLM id
    @objc dynamic var name:String       = ""
    @objc dynamic var creatTime:Int     = 0
    
    //設置索引主鍵
    override static func primaryKey() -> String {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    required convenience init?(record:RLM_Record) {
        self.init()
        name        = record.name
        creatTime   = record.creatTime
    }
}

// MARK: RLM_RecordUtil Data操作相關
struct RLM_RecordUtil{
    
    static var sharedInstance = RLM_RecordUtil()
    let realm = try! Realm()
    
    ///儲存集點資料
    func saveRecord(record: RLM_Record, completion:((Bool)->())){
        guard let record = RLM_Record(record: record) else{
            completion(false)
            return
        }
        do{
            try realm.write(
                transactionBlock: {
                    realm.add(record, update: true)
            },completion: {
                completion(true)
            })
        }catch let error {
            //CrashReport.log(error.localizedDescription)
            //CrashReport.log("\(user.userid) 存入DB失敗")
            print("\(record.id) 存入DB失敗 原因\(error.localizedDescription)")
            completion(false)
        }
    }
    
    ///清除集點資料
    func deleteRecord(){
        if let record = realm.objects(RLM_Record.self).first {
            try! realm.write {
                realm.delete(record)
            }
        }
    }
    
    ///取得集點資料
    func getRecords() -> [RLM_Record]{
        let record = realm.objects(RLM_Record.self)
        guard record.count > 0 else {
            return [RLM_Record]()
        }
        return Array(record)
    }
    
}
