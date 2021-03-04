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
    let database = Database.database(url: "https://testdiscdb-users-rtdb.firebaseio.com/")
    let dbRef = Database.database(url: "https://testdiscdb-users-rtdb.firebaseio.com/").reference()
    
    //  MARK: - Methods
    
    /// checks if user email already exists and, if not, creates new user object in firebase User database
    func insertNewUserWith(userID: String, email: String, completion: @escaping (Bool) -> Void) {
        //  if user already exists, return
        
        dbRef.child(userID).setValue([
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
        dbRef.child(userID).updateChildValues([key : value])
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

    
}
