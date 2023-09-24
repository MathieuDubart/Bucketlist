//
//  ContentView.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinates) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.yellow)
                            // ----- 44 x 44 est la taille minimum recommandée par Apple pour les éléments interactifs
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.setNewLocation()
                        } label: {
                            Image(systemName: "plus")
                                .background(.black.opacity(0.75))
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.updateLocation(with: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .alert("Authentication error", isPresented: $viewModel.isShowingAutenticationError) {
                Button("OK"){}
            } message: {
                HStack{
                    Image(systemName: "warning")
                    Text(viewModel.authenticationError)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
