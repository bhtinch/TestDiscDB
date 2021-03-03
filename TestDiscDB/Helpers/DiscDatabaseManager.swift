//
//  LocalDatabase.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/24/21.
//
import FirebaseDatabase
import Foundation

struct DiscKeys {
    //  Disc Object
    static let approvalDate = "Approved Date"
    static let availPlastics = "Available Plastics"
    static let certNumber = "Certification Number"
    static let discClass = "Class"
    static let diameter = "Diameter (cm)"
    static let model = "Disc Model"
    static let fade = "Fade"
    static let flexibility = "Flexibility (kg)"
    static let glide = "Glide"
    static let height = "Height (cm)"
    static let inProdcution = "In Production"
    static let insideRimDia = "Inside Rim Diameter (cm)"
    static let link = "Link"
    static let brand = "Manufacturer Or Distributor"
    static let maxWeight = "Max Weight (gr)"
    static let rimConfig = "Rim Configuration"
    static let rimDepth = "Rim Depth (cm)"
    static let rimDepthToDiameterRatio = "Rim Depth To Diameter Ratio (%)"
    static let rimThickness = "Rim Thickness (cm)"
    static let speed = "Speed"
    static let turn = "Turn"
    static let type = "Type"
    static let discID = "uid"
}

class DiscDatabaseManager {
    //  MARK: - Properties
    static let shared = DiscDatabaseManager()
    let database = Database.database().reference()
    
    //  MARK: - Methods
    func getDiscWith(uid: String, completion: @escaping (Result<Disc, NetworkError>) -> Void) {
        
        database.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() == false {
                return completion(.failure(NetworkError.noData))
            }
            
            let approvalDate = snapshot.childSnapshot(forPath: DiscKeys.approvalDate).value as? Date ?? nil
            let plastics = snapshot.childSnapshot(forPath: DiscKeys.availPlastics).value as? String ?? ""
            let certNumber = snapshot.childSnapshot(forPath: DiscKeys.certNumber).value as? String ?? ""
            let modelClass = snapshot.childSnapshot(forPath: DiscKeys.discClass).value as? String ?? ""
            let diameter = snapshot.childSnapshot(forPath: DiscKeys.diameter).value as? Double ?? nil
            let model = snapshot.childSnapshot(forPath: DiscKeys.model).value as? String ?? ""
            let fade = snapshot.childSnapshot(forPath: DiscKeys.fade).value as? Double ?? nil
            let flexibility = snapshot.childSnapshot(forPath: DiscKeys.flexibility).value as? Double ?? nil
            let glide = snapshot.childSnapshot(forPath: DiscKeys.glide).value as? Double ?? nil
            let height = snapshot.childSnapshot(forPath: DiscKeys.height).value as? Double ?? nil
            let inProduction = snapshot.childSnapshot(forPath: DiscKeys.inProdcution).value as? String ?? ""
            let insideRimDia = snapshot.childSnapshot(forPath: DiscKeys.insideRimDia).value as? Double ?? nil
            let linkURLString = snapshot.childSnapshot(forPath: DiscKeys.link).value as? String ?? ""
            let make = snapshot.childSnapshot(forPath: DiscKeys.brand).value as? String ?? ""
            let maxWeight = snapshot.childSnapshot(forPath: DiscKeys.maxWeight).value as? Int ?? nil
            let rimConfig = snapshot.childSnapshot(forPath: DiscKeys.rimConfig).value as? Double ?? nil
            let rimDepth = snapshot.childSnapshot(forPath: DiscKeys.rimDepth).value as? Double ?? nil
            let rimDepthToDiaRatio = snapshot.childSnapshot(forPath: DiscKeys.rimDepthToDiameterRatio).value as? Double ?? nil
            let thickness = snapshot.childSnapshot(forPath: DiscKeys.rimThickness).value as? Double ?? nil
            let speed = snapshot.childSnapshot(forPath: DiscKeys.speed).value as? Int ?? nil
            let turn = snapshot.childSnapshot(forPath: DiscKeys.turn).value as? Double ?? nil
            let type = snapshot.childSnapshot(forPath: DiscKeys.type).value as? String ?? ""
            let uid = uid
            
            let disc = Disc(approvalDate: approvalDate, plastics: plastics, certNumber: certNumber, modelClass: modelClass, diameter: diameter, model: model, fade: fade, flexibility: flexibility, glide: glide, height: height, inProduction: inProduction, insideRimDia: insideRimDia, linkURLString: linkURLString, make: make, maxWeight: maxWeight, rimConfig: rimConfig, rimDepth: rimDepth, rimDepthToDiaRatio: rimDepthToDiaRatio, thickness: thickness, speed: speed, turn: turn, type: type, uid: uid)
            
            return completion(.success(disc))
        }
    }
    
    func queryDiscsWith(brand: String?, model: String?) {
        
    }
}   //  End of Class
