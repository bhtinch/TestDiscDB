//
//  DatabaseManager.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/23/21.
//
import FirebaseDatabase
import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var discList = {[
        [
            "Approved Date" : String(),
            "Available Plastics" : String(),
            "Fade" : Double()
        ]
    ]}()
    
}
