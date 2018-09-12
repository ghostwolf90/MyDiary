//
//  RealmMigration.swift
//  QLiEERPhoenix
//
//  Created by florachen on 2017/12/8.
//  Copyright © 2017年 QLIEER. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmMigration {
    
    public static let localRealmVersion = 1
    
    func didApplicationLunch () {
        self.migrationVersion()
    }
    
    func migrationVersion() {
        
        let config = Realm.Configuration(
           
            schemaVersion : UInt64(RealmMigration.localRealmVersion) ,
            
            migrationBlock : { migration , oldSchemaVersion in
                
                if (oldSchemaVersion < 21) {
                    // The renaming operation should be done outside of calls to `enumerate(_:)`.
                    //migration.renameProperty(onType: RLM_Closing.className(), from: "orderNum", to: "orderNumber")
                }
                
        },
            deleteRealmIfMigrationNeeded: true
            
        )
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}


// MARK: - query結果可支援轉Array
extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        return array
    }
    
}


// MARK: - Realm Object to json
extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties as [Property]! {
            // find lists
            print(prop.objectClassName)
            if let objectClassName = prop.objectClassName  {
                if let nestedObject = self[prop.name] as? Object {
                    mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name.replacingOccurrences(of: "_", with: ""))
                } else if let nestedListObject = self[prop.name] as? ListBase {
                    var objects = [AnyObject]()
                    for index in 0..<nestedListObject._rlmArray.count  {
                        if let object = nestedListObject._rlmArray[index] as? Object {
                            objects.append(object.toDictionary())
                        }
                    }
                    mutabledic.setObject(objects, forKey: prop.name.replacingOccurrences(of: "_", with: "") as NSCopying)
                }
            }
        }
        return mutabledic
    }
}


// MARK: - 取得寫入完成callback
extension Realm {
    
    /** Performs actions contained within the given block inside a write transaction with
     completion block.
     
     - parameter block: write transaction block
     - completion: completion executed after transaction block
     */
    func write( transactionBlock block: () -> (), completion: () -> ()) throws {
        do {
            try write(block)
            completion()
        } catch {
            throw error
        }
    }
}

// MARK: - UnmanagedCopy Protocol
protocol UnmanagedCopy {
    func unmanagedCopy() -> Self
}

extension Object: UnmanagedCopy{
    func unmanagedCopy() -> Self {
        let o = type(of:self).init()
        for p in objectSchema.properties {
            let value = self.value(forKey: p.name)
            switch p.type {
            case .linkingObjects:
                break
            default:
                o.setValue(value, forKey: p.name)
            }
        }
        
        return o
    }
}


protocol CascadeDeleting: class {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
}

extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }
    
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        } else {
            delete(entity)
        }
    }
}

private extension Realm {
    
    func cascadeDelete(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }

        entity.objectSchema.properties.forEach { property in
            if let value = entity.value(forKey: property.name) {
                if let entity = value as? RLMObjectBase {
                    cascadeDelete(entity)
                } else if let list = value as? RealmSwift.ListBase {
                    while let item = list._rlmArray.firstObject() {
                        if let item = item as? RLMObjectBase {
                            cascadeDelete(item)
                        }
                    }
                }
            }
        }

        if !entity.isInvalidated {
            self.delete(entity)
        }
    }

}

