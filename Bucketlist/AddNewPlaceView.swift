//
//  AddNewPlaceView.swift
//  Bucketlist
//
//  Created by Mathieu DUBART on 06/10/2023.
//

import SwiftUI

struct AddNewPlaceView: View {
    @State private var placeName = ""
    var body: some View {
        // ---- rajouter choix de couleur, nom et symbole.
        TextField(text: $placeName, prompt: Text("Place name")) {
            HStack {
                Image(systemName: "mappin")
                Text("Place Name")
            }
        }
    }
}

#Preview {
    AddNewPlaceView()
}
