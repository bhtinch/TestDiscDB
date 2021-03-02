//
//  RackController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/26/21.
//

import Foundation

class RackController {
    static let shared = RackController()
    
    var racks: [Rack] = []
    
    func createNewRackWith(name: String, isDefault: Bool) {
        
        let rack = Rack(name: name)
        
        if racks.count == 0 {
            rack.isDefault = true
        }
        else if isDefault {
            rack.isDefault = true
            
            for other in racks {
                other.isDefault = false
            }
        }
        
        racks.append(rack)
    }
    
    func delete(rack: Rack) {
        guard let index = racks.firstIndex(of: rack) else { return }
        racks.remove(at: index)
        if racks.count != 0 { racks[0].isDefault = true }
    }
    
    func addDiscToRackWith(disc: Disc, rack: Rack) {
        rack.discs.append(disc)
    }
    
    func removeDiscFromRack(disc: Disc, rack: Rack) {
        guard let index = rack.discs.firstIndex(of: disc) else { return }
        rack.discs.remove(at: index)
    }
    
    func fetchRacks() {
        self.racks = UserDatabaseManager.shared.getUserRacks()
    }
}
