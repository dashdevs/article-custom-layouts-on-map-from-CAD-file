//
//  MapsListView.swift
//  GMaps
//
//  Created by yurii on 28.07.2022.
//

import SwiftUI
import Combine

struct MapsListView: View {
    @StateObject private var mapsDataFetcher: MapsListViewModel = .init()
    @State private var mapsData: [MapData] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mapsData) { mapData in
                    NavigationLink {
                        GoogleMapsView(mapData: mapData)
                    } label: {
                        MapDataLabelView(mapData: mapData)
                    }
                }
            }
            .navigationTitle("Maps")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            mapsDataFetcher.fetchData()
        }
        .onReceive(mapsDataFetcher.mapsData) {
            mapsData = $0
        }
    }
    
    class MapsListViewModel: NetworkManager<MapData> {
        let mapsData = PassthroughSubject<[MapData], Never>()
        func fetchData() {
            let pubs: [AnyPublisher<MapData, Never>] = Bundle.main.paths(forResourcesOfType: "geojson", inDirectory: nil)
                .map { URL(fileURLWithPath: $0) }
                .compactMap { URLRequest(url: $0) }
                .map(call)
            
            Publishers.MergeMany(pubs)
                .collect()
                .sink { [weak self] in
                    self?.mapsData.send($0)
                }
                .store(in: &storage)
        }
    }
}
