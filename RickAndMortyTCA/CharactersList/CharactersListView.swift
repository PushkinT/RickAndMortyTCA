//
//  CharactersListView.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import SwiftUI
import ComposableArchitecture
import NukeUI

struct CharactersListView: View {
    // MARK: - Stores properties
    private let store: StoreOf<CharactersListFeature>
    
    init(store: StoreOf<CharactersListFeature>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            List {
                ForEach(store.characters, id: \.id) { character in
                    // MARK: - Character Cell
                    NavigationLink(state: CharacterDetailFeature.State(character: character)) {
                        HStack {
                            VStack {
                                LazyImage(url: URL(string: character.image)) { state in
                                    if let image = state.image {
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    }
                                }
                                .frame(width: 150, height: 150)
                                .clipShape(.rect(cornerRadius: 16))
                                .shadow(color: .gray, radius: 16, x: 10, y: 10)
                                .padding()
                                Spacer()
                            }
                            
                            
                            VStack(alignment: .leading,spacing: 8) {
                                Text(character.name)
                                    .font(.title3)
                                    .bold()
                                Text(character.status)
                                    .font(.callout)
                                Text(character.gender)
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Rick and Morty")
                
                // MARK: - Infifnity scroll view
                if !store.characters.isEmpty {
                    ProgressView(label: {
                        Text("The End")
                    })
                    .onAppear { store.send(.fetchNextCharacters) }
                }
            }
            .task { store.send(.fetchFirstCharacters) }
            } destination: { store in
                CharacterDetailView(store: store)
            }
            
    }
}
