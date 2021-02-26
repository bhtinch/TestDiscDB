//
//  UserDatabaseManager.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/25/21.
//
import FirebaseDatabase
import FirebaseAuth
import Foundation

class UserDatabaseManager {
    static let shared = UserDatabaseManager()
    private var database = Database.database(url: "https://testdiscdb-users-rtdb.firebaseio.com/").reference()
    
    //  MARK: - Methods
    
    /// checks if user email already exists and, if not, creates new user object in firebase User database
    func insertNewUserWith(email: String, completion: @escaping (Bool) -> Void) {
        //  if user already exists, return
        
        let FIRemail = email.safeDatabaseKey()
        
        database.child(FIRemail).setValue([
            "Date Joined" : "\(Date())",
            "myBag" : ["No discs yet"]
        ])
        
        completion(true)
    }
    
    /// Attempts to remove the user object from the firebase User database
    func deleteUserWith() {
        
    }
    
    /// Attempts to update the child data of the user object in the firebase User database
    func updateUser() {
        
    }
    
    func getUserData() {
        let userEmail = Auth.auth().currentUser?.email
        let FIRemail = userEmail?.safeDatabaseKey()
        
        database.queryEqual(toValue: FIRemail).getData { (error, snapshot) in
            print(snapshot)
        }
    }
}
