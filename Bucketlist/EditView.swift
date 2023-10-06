//
//  EditView.swift
//  Bucketlist
//
//  Created by Mathieu Dubart on 24/09/2023.
//

import SwiftUI

struct EditView: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                    
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                             + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    // ----- @escaping signifie que la fonction onSave ne sera pas appelée toute de suite au build du init mais plus tard
    init(location: Location, onSave: @escaping (Location) -> Void) {
        
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
}

#Preview {
    EditView(location: Location.example) { _ in }
}
