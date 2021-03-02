//
//  AuthManager.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/25/21.
//

import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    /// Attempt to register a new user with Firebase Authentication
    func registerNewUserWith(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard error == nil,
                  let userID = authResult?.user.uid else { return completion(false) }
            
            UserDatabaseManager.shared.insertNewUserWith(userID: userID, email: email) { (test) in
                if test {
                    print("New Firebase User added to the user database.")
                    return completion(true)
                } else {
                    //  ERROR
                }
            }
        }
    }
    
    /// Attempt to login firebase user
    func loginUserWith(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard error == nil, authResult != nil else { return completion(false) }
            
            return completion(true)
        }
    }
    
    /// Attempt to logout firebase user
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("firebase user logged out")
        } catch {
            print("Could not sign out.")
        }
    }
    
    func deleteUser(){
        //  NEEDS IMPLEMENTATION
    }
    
}
