//
//  Rack.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/26/21.
//

import Foundation

class Rack {
    var name: String
    var discs: [Disc]
    var isDefault: Bool
    var uuidString: String
    
    init(name: String, discs: [Disc] = [], isDefault: Bool = false, uuidString: String = UUID().uuidString) {
        self.name = name
        self.discs = discs
        self.isDefault = isDefault
        self.uuidString = uuidString
    }
}

extension Rack: Equatable {
    static func == (lhs: Rack, rhs: Rack) -> Bool {
        return lhs.uuidString == rhs.uuidString
    }
}
