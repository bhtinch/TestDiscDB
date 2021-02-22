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
    
    func addDiscToBagWith(make: String, model: String) {
        let disc = Disc(model: model, make: make)
        myBag.append(disc)
        saveToPersistenceStore()
    }
    
    func removeDiscFromBag(index: Int) {
        myBag.remove(at: index)
        saveToPersistenceStore()
    }
    
    //  MARK: - Persistence
    
    //  fileURL
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("Bag.json")
        return fileURL
    }
    
    //  save
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(myBag)
            try data.write(to: fileURL())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    //  load
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
