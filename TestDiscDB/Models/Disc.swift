//
//  Disc.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/22/21.
//

import Foundation

class Disc: Codable {
    let approvalDate: Date?
    let plastics: String
    let certNumber: String
    let modelClass: String
    let diameter: Double?
    let model: String
    let fade: Double?
    let flexibility: Double?
    let glide: Double?
    let height: Double?
    let inProduction: String
    let insideRimDia: Double?
    let linkURLString: String
    let make: String
    let maxWeight: Int?
    let rimConfig: Double?
    let rimDepth: Double?
    let rimDepthToDiaRatio: Double?
    let thickness: Double?
    let speed: Int?
    let turn: Double?
    let type: String
    let uuid: String
    
    init(approvalDate: Date?, plastics: String, certNumber: String, modelClass: String, diameter: Double?, model: String, fade: Double?, flexibility: Double?, glide: Double?, height: Double?, inProduction: String, insideRimDia: Double?, linkURLString: String, make: String, maxWeight: Int?, rimConfig: Double?, rimDepth: Double?, rimDepthToDiaRatio: Double?, thickness: Double?, speed: Int?, turn: Double?, type: String, uuid: String = UUID().uuidString) {
        self.approvalDate = approvalDate
        self.plastics = plastics
        self.certNumber = certNumber
        self.modelClass = modelClass
        self.diameter = diameter
        self.model = model
        self.fade = fade
        self.flexibility = flexibility
        self.glide = glide
        self.height = height
        self.inProduction = inProduction
        self.insideRimDia = insideRimDia
        self.linkURLString = linkURLString
        self.make = make
        self.maxWeight = maxWeight
        self.rimConfig = rimConfig
        self.rimDepth = rimDepth
        self.rimDepthToDiaRatio = rimDepthToDiaRatio
        self.thickness = thickness
        self.speed = speed
        self.turn = turn
        self.type = type
        self.uuid = uuid
    }
}

extension Disc: Equatable {
    static func == (lhs: Disc, rhs: Disc) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
