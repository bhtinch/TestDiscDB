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
            
            guard error == nil, authResult != nil else { return completion(false) }
            
            return completion(true)
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
    func logoutUser(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            return completion(true)
        } catch {
            print("Could not sign out.")
            return completion(false)
        }
    }
    
}
