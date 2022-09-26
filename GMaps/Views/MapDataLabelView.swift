//
//  MapDataLabelView.swift
//  GMaps
//
//  Created by yurii on 28.07.2022.
//

import SwiftUI

struct MapDataLabelView: View {
    let mapData: MapData
    
    var body: some View {
        HStack {
            Text("Location name: ")
            Spacer()
            Text("\(mapData.name)")
        }
    }
}
