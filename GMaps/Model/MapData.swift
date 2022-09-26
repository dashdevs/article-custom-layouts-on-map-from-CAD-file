//
//  MapData.swift
//  GMaps
//
//  Created by yurii on 27.07.2022.
//

import Foundation

struct MapData: Decodable, Identifiable {
    let name: String
    let features: [Feature]
    var id: String { name }
}

struct Feature: Decodable {
    let geometry: Geometry
}

struct Geometry: Decodable {
    let coordinates: [[Double]]
}
