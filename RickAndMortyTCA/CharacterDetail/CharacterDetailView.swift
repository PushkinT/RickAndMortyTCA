//
//  CharacterDetailView.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct CharacterDetailView: View {
    
    @Bindable var store: StoreOf<CharacterDetailFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .center) {
                
                LazyImage(url: URL(string: store.character.image)) { state in
                    if let image = state.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 16))
                .shadow(color: .gray, radius: 16, x: 10, y: 10)
            }
            
            Text(store.character.name)
                .font(.largeTitle)
                .bold()

            Text("Gender: ") + Text(store.character.gender)
                .font(.title)
                .fontWeight(.light)
            
            Text("Status: ") + Text(store.character.status)
                .font(.title)
                .fontWeight(.light)
            
            Text("Species: ") + Text(store.character.species)
                .font(.title)
                .fontWeight(.light)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.character.name)
    }
}

