//
//  ContentView.swift
//  NearMeAppSwift
//
//  Created by Michele Manniello on 29/01/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var search : String = ""
    @ObservedObject var locationmanager = LocationManager()
    @State private var landmarks: [Landmark] = [Landmark]()
    @State private var tapped: Bool = false
    
    private func getNearBylandmarks(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
                let mapItems = response.mapItems
                self.landmarks = mapItems.map({
                    Landmark(placemark: $0.placemark)
                })
                
            }
        }
    }
    func calculateOffset() -> CGFloat {
        if self.landmarks.count > 0 && !self.tapped{
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
        }else if self.tapped{
            return 100
        }else{
            return UIScreen.main.bounds.size.height
        }
    }
    
    var body: some View {
        ZStack(alignment:.top){
            MapView(landmarks: landmarks)
            TextField("Search",text: $search,onEditingChanged: { _ in
            }){
//                commit
                self.getNearBylandmarks()
            }.textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .offset(y:44)
            PlaceListView(landmarks: self.landmarks) {
//                on tap
                self.tapped.toggle()
                print("cliccato")
//                do something
            }.animation(.spring())
            .offset(y:calculateOffset())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
