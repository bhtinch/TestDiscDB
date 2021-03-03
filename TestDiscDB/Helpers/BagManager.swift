//
//  BagManager.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 3/2/21.
//

import Foundation
import FirebaseDatabase

struct BagKeys {
    static let bagID = "bagID"
    static let discIDs = "discs"
    static let name = "name"
    static let brand = "brand"
    static let model = "model"
    static let color = "color"
    static let isDefault = "isDefault"
}

class BagManager {
    
    static let database = UserDatabaseManager.shared.database
    
    static func getDefaultBag(completion: @escaping (Result<Bag, NetworkError>) -> Void) {
        let pathString = "\(UserKeys.userID)/\(UserKeys.bags)"
        
        database.child(pathString).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChildren() == false {
                return completion(.failure(NetworkError.noData))
            }
            
            for child in snapshot.children.allObjects {
                guard let childSnap = child as? DataSnapshot,
                      let test = childSnap.childSnapshot(forPath: BagKeys.isDefault).value as? Bool else { return completion(.failure(NetworkError.databaseError)) }
                if test {
                    let bagID = childSnap.key
                    let name = childSnap.childSnapshot(forPath: BagKeys.name).value as? String ?? ""
                    let brand = childSnap.childSnapshot(forPath: BagKeys.brand).value as? String ?? ""
                    let model = childSnap.childSnapshot(forPath: BagKeys.model).value as? String ?? ""
                    let color = childSnap.childSnapshot(forPath: BagKeys.color).value as? String ?? ""
                    let isDefault = childSnap.childSnapshot(forPath: BagKeys.isDefault).value as? Bool ?? false
                    
                    guard let NSdiscIDs = childSnap.childSnapshot(forPath: BagKeys.discIDs).value as? NSDictionary else { return }
                    
                    let discIDs = NSdiscIDs as? Dictionary<String, String> ?? Dictionary()
                    
                    let bag = Bag(name: name, brand: brand, model: model, color: color, discIDs: discIDs, isDefault: isDefault, uuidString: bagID)
                    return completion(.success(bag))
                }
            }
            
            database.child(pathString).queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snap) in
                print(snap.key)
                for child in snap.children {
                    guard let childSnap = child as? DataSnapshot else { return completion(.failure(NetworkError.databaseError)) }
                    let key = childSnap.key as String
                    
                    let bagID = key
                    let name = childSnap.childSnapshot(forPath: BagKeys.name).value as? String ?? ""
                    let brand = childSnap.childSnapshot(forPath: BagKeys.brand).value as? String ?? ""
                    let model = childSnap.childSnapshot(forPath: BagKeys.model).value as? String ?? ""
                    let color = childSnap.childSnapshot(forPath: BagKeys.color).value as? String ?? ""
                    let isDefault = childSnap.childSnapshot(forPath: BagKeys.isDefault).value as? Bool ?? false
                    guard let NSdiscIDs = childSnap.childSnapshot(forPath: BagKeys.discIDs).value as? NSDictionary else { return }
                    
                    let discIDs = NSdiscIDs as? Dictionary<String, String> ?? Dictionary()
                    
                    let bag = Bag(name: name, brand: brand, model: model, color: color, discIDs: discIDs, isDefault: isDefault, uuidString: bagID)
                    
                    return completion(.success(bag))
                }
            }
        }
    }
    
    static func getBagWith(bagID: String, completion: @escaping (Result<Bag, NetworkError>) -> Void) {
        
        let pathString = "\(UserKeys.userID)/\(UserKeys.bags)/\(bagID)"
        print(pathString)
        
        database.child(pathString).observeSingleEvent(of: .value) { (snap) in
            if snap.childSnapshot(forPath: BagKeys.discIDs).exists() == false {
                return completion(.failure(NetworkError.noData))
            } else {
                let bagID = snap.key as String
                let name = snap.childSnapshot(forPath: BagKeys.name).value as? String ?? ""
                let brand = snap.childSnapshot(forPath: BagKeys.brand).value as? String ?? ""
                let model = snap.childSnapshot(forPath: BagKeys.model).value as? String ?? ""
                let color = snap.childSnapshot(forPath: BagKeys.color).value as? String ?? ""
                let isDefault = snap.childSnapshot(forPath: BagKeys.isDefault).value as? Bool ?? false
                guard let NSdiscIDs = snap.childSnapshot(forPath: BagKeys.discIDs).value as? NSDictionary else { return completion(.failure(NetworkError.databaseError))}
                
                let discIDs = NSdiscIDs as? Dictionary<String, String> ?? Dictionary()
                
                let bag = Bag(name: name, brand: brand, model: model, color: color, discIDs: discIDs, isDefault: isDefault, uuidString: bagID)
                
                return completion(.success(bag))
            }
        }
    }
    
    static func createNewBagWith(name: String, brand: String, model: String, color: String, isDefault: Bool) {
        let pathString = "\(UserKeys.userID)/\(UserKeys.bags)"
                
        database.child(pathString).childByAutoId().setValue([
            BagKeys.name : name,
            BagKeys.brand : brand,
            BagKeys.model : model,
            BagKeys.color : color,
            BagKeys.isDefault : isDefault,
            BagKeys.discIDs : [String]()
        ]) { (error, dbRef) in
            dbRef.observeSingleEvent(of: .value) { (snap) in
                print(snap.key)
            }
        }
        
        //return bag
    }
}   //  End of Class
