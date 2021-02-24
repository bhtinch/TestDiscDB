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
    
    func addDiscToBagWith(disc: Disc) {
        myBag.append(disc)
        self.saveToPersistenceStore()
    }
    
    func removeDiscFromBag(index: Int) {
        myBag.remove(at: index)
        self.saveToPersistenceStore()
    }
    
    //  MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("Bag.json")
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(myBag)
            try data.write(to: fileURL())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: fileURL())
            let loaded = try JSONDecoder().decode([Disc].self, from: data)
            myBag = loaded
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
