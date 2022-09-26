//
//  GMapsApp.swift
//  GMaps
//
//  Created by yurii on 27.07.2022.
//

import SwiftUI
import GoogleMaps

@main
struct GMapsApp: App {
    
    init() {
        GMSServices.provideAPIKey("YOUR_API_KEY")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
