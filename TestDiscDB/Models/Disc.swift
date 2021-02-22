//
//  Disc.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//

import Foundation

class Disc: Codable {
    let model: String
    let make: String
    
    init(model: String, make: String) {
        self.model = model
        self.make = make
    }
}

extension Disc: Equatable {
    static func == (lhs: Disc, rhs: Disc) -> Bool {
        return lhs.make == rhs.make && lhs.model  == rhs.model
    }
}
