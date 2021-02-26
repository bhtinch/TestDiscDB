//
//  Bag.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//

import Foundation

class Bag {
    static let shared = Bag()
    
    var myBag: [Disc] = []
    var myNSBag: [NSString] = []
    
    func addDiscToBagWith(disc: Disc) {
        myBag.append(disc)
        myNSBag.append(disc.uuid as NSString)
        UserDatabaseManager.shared.updateUser()
    }
    
    func removeDiscFromBag(index: Int) {
        myBag.remove(at: index)
        myNSBag.remove(at: index)
        UserDatabaseManager.shared.updateUser()
    }
    
    func fetchDiscs() {
        UserDatabaseManager.shared.getUserData()
        
        //  use completion block on getUserData to build a bag of [Disc] from the uuid data stored in 'myBag' key on database
        
        /*  something like:
        for index in [user database myBag uuids] {
            for disc in LocalDatabase.shared.localDatabase {
                if uuid == disc.uuid { myBag.append(disc) }
            }
        }
        */
    }
    
}
