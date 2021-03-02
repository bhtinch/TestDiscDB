//
//  LocalDatabase.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/24/21.
//
import FirebaseDatabase
import Foundation

class LocalDatabase {
    //  MARK: - Properties
    static let shared = LocalDatabase()
    private let database = Database.database().reference()
    var localDatabase: [Disc] = []
    
    //  MARK: - Methods
    func syncDatabase(completion: @escaping (Result<String, NetworkError>) -> Void) {
        localDatabase = []
        
        DispatchQueue.main.async {
            self.database.getData { (error, snapshot) in
                if let error = error {
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                    return completion(.failure(.noData))
                }
                
                for index in 0..<snapshot.childrenCount {
                    
                    let approvalDate = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Approved Date").value as? Date ?? nil
                    
                    let plastics = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Available Plastics").value as? String ?? ""
                    
                    let certNumber = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Certification Number").value as? String ?? ""
                    
                    let modelClass = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Class").value as? String ?? ""
                    
                    let diameter = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Diameter (cm)").value as? Double ?? nil
                    
                    let model = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Disc Model").value as? String ?? ""
                    
                    let fade = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Fade").value as? Double ?? nil
                    
                    let flexibility = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Flexibility (kg)").value as? Double ?? nil
                    
                    let glide = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Glide").value as? Double ?? nil
                    
                    let height = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Height (cm)").value as? Double ?? nil
                    
                    let inProduction = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "In Production").value as? String ?? ""
                    
                    let insideRimDia = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Inside Rim Diameter").value as? Double ?? nil
                    
                    let linkURLString = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Link").value as? String ?? ""
                    
                    let make = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Manufacturer Or Distributor").value as? String ?? ""
                    
                    let maxWeight = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Max Weight (gr)").value as? Int ?? nil
                    
                    let rimConfig = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Rim Configuration").value as? Double ?? nil
                    
                    let rimDepth = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Rim Depth(cm)").value as? Double ?? nil
                    
                    let rimDepthToDiaRatio = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Rim Depth To Diameter Ratio (%)").value as? Double ?? nil
                    
                    let thickness = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Rim Thickness (cm)").value as? Double ?? nil
                    
                    let speed = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Speed").value as? Int ?? nil
                    
                    let turn = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Turn").value as? Double ?? nil
                    
                    let type = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "Type").value as? String ?? ""
                    
                    let uuid = snapshot.childSnapshot(forPath: "\(index)").childSnapshot(forPath: "uuid").value as? String ?? ""
                    
                    let disc = Disc(approvalDate: approvalDate, plastics: plastics, certNumber: certNumber, modelClass: modelClass, diameter: diameter, model: model, fade: fade, flexibility: flexibility, glide: glide, height: height, inProduction: inProduction, insideRimDia: insideRimDia, linkURLString: linkURLString, make: make, maxWeight: maxWeight, rimConfig: rimConfig, rimDepth: rimDepth, rimDepthToDiaRatio: rimDepthToDiaRatio, thickness: thickness, speed: speed, turn: turn, type: type, uuid: uuid)

                    self.localDatabase.append(disc)
                }
                self.saveToPersistenceStore()
                return completion(.success("Data successfully fetched."))
            }
        }
    }
    
    //  MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("LocalDatabase.json")
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(localDatabase)
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
            localDatabase = loaded
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
