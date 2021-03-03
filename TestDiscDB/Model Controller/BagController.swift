//
//  Bag.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//

import Foundation

class BagController {
    static let shared = BagController()
    
    //var bags: [Bag] = []
    
    func createNewBagWith(name: String, brand: String?, model: String?, color: String?, isDefault: Bool) {
        
        let _ = Bag(name: name, brand: brand, model: model, color: color)
        
//        if bags.count == 0 {
//            bag.isDefault = true
//        }
//
//        if isDefault {
//            bag.isDefault = true
//
//            for other in bags {
//                other.isDefault = false
//                UserDatabaseManager.shared.updateUserBagWith(bag: other)
//            }
//        }
//        bags.append(bag)
    }
    
//    func delete(bag: Bag) {
//        guard let index = bags.firstIndex(of: bag) else { return }
//        bags.remove(at: index)
//        if bags.count != 0 { bags[0].isDefault = true }
//    }
//
//    func addDiscToBagWith(disc: Disc, bag: Bag) {
//        bag.discs.append(disc)
//        bag.discIDs.append(disc.uid)
//        UserDatabaseManager.shared.updateUserBagWith(bag: bag)
//    }
//
//    func removeDiscFromBag(disc: Disc, bag: Bag) {
//        guard let index = bag.discs.firstIndex(of: disc) else { return }
//        bag.discs.remove(at: index)
//        bag.discIDs.remove(at: index)
//    }
    
//    func fetchAllBags() {
//        //self.bags = UserDatabaseManager.shared.getUserBags()
//    }
    
}
