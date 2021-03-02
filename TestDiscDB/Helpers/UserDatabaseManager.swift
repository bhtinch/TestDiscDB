//
//  UserDatabaseManager.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/25/21.
//
import FirebaseDatabase
import FirebaseAuth
import Foundation

struct UserKeys {
    //  User Object
    static let dateJoined = "Date Joined"
    static let bags = "Bags"
    static let racks = "Racks"
    static let email = "Email"
    static let userID = Auth.auth().currentUser?.uid ?? "No User"
}

class UserDatabaseManager {
    static let shared = UserDatabaseManager()
    var database = Database.database(url: "https://testdiscdb-users-rtdb.firebaseio.com/").reference()
    
    //  MARK: - Methods
    
    /// checks if user email already exists and, if not, creates new user object in firebase User database
    func insertNewUserWith(userID: String, email: String, completion: @escaping (Bool) -> Void) {
        //  if user already exists, return
        
        database.child(userID).setValue([
            UserKeys.email : email,
            UserKeys.dateJoined : "\(Date())",
        ])
                
        completion(true)
    }
    
    /// Attempts to remove the user object from the firebase User database
    func deleteUserWith() {
        
    }
    
    /// Attempts to update the child data of the user object in the firebase User database; currently valid only for single level top level children
    func updateUserWith(key: String, value: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        database.child(userID).updateChildValues([key : value])
    }
    
//    func updateUserBagWith(bag: Bag) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let bagID = bag.uuidString
//        let pathString = userID + "/" + UserKeys.bags + "/" + bagID
//
//        database.child(pathString).updateChildValues([
//            UserKeys.bagName : bag.name,
//            UserKeys.bagBrand : bag.brand ?? "",
//            UserKeys.bagModel : bag.model ?? "",
//            UserKeys.bagColor : bag.color ?? "",
//            UserKeys.isDefault : bag.isDefault,
//            UserKeys.discIDs : bag.discIDs
//        ])
//    }
//
//    func getAllUserData() {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//
//        database.child(userID).getData { (error, snapshot) in
//            print(snapshot)
//        }
//    }
//
//    func addUserBagWith(name: String, brand: String, model: String, color: String, isDefault: Bool) {
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        let pathString = "\(userID)/\(UserKeys.bags)"
//
//        database.child(pathString).childByAutoId().setValue([
//            UserKeys.bagName : name,
//            UserKeys.bagBrand : brand,
//            UserKeys.bagModel : model,
//            UserKeys.bagColor : color,
//            UserKeys.isDefault : isDefault,
//            UserKeys.discIDs : [String]()
//        ])
//    }
    
    func getUserBagWith(id: String) -> [Bag] {
        guard let userID = Auth.auth().currentUser?.uid else { return [] }
        let pathString = "\(userID)/\(UserKeys.bags)"
        
        var bags = [Bag]()
                
                
                //                for index in 0..<snapshot.childrenCount {
                //                    let discIDs =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.discIDs).value as? [String] ?? []
                //                    let name =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.bagName).value as? String ?? ""
                //                    let brand =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.bagBrand).value as? String ?? ""
                //                    let model =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.bagModel).value as? String ?? ""
                //                    let color =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.bagColor).value as? String ?? ""
                //                    let isDefault =  snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: UserKeys.isDefault).value as? Bool ?? false
                //                    let bagID =  snapshot.childSnapshot(forPath: "\(index)").value as? String ?? ""
                //
                //                    var discs = [Disc]()
                //
                //                    for discID in discIDs {
                //                        let foundDisc = LocalDatabase.shared.localDatabase.first { (localDisc) -> Bool in
                //                            return localDisc.uuid == discID
                //                        }
                //                        guard let disc = foundDisc else { return }
                //                        discs.append(disc)
                //                    }
                //
                //                    let bag = Bag(name: name, brand: brand, model: model, color: color, discs: discs, discIDs: discIDs, isDefault: isDefault, uuidString: bagID)
                //                    bags.append(bag)
                //                }
        return bags
    }
    
    func getUserRacks() -> [Rack] {
        return []
    }
}
