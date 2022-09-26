//
//  GoogleMapsView.swift
//  GMaps
//
//  Created by yurii on 27.07.2022.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct GoogleMapsView: UIViewRepresentable {
    let mapData: MapData
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: mapData.features[0].geometry.coordinates[0][1],
                                              longitude: mapData.features[0].geometry.coordinates[0][0],
                                              zoom: 13)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        if let url = Bundle.main.url(forResource: mapData.name, withExtension: "geojson") {
            let geoJsonParser = GMUGeoJSONParser(url: url)
            geoJsonParser.parse()

            let renderer = GMUGeometryRenderer(map: mapView, geometries: geoJsonParser.features)
            renderer.render()
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}
