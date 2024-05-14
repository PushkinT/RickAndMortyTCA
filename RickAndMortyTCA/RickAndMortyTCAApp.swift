//
//  RickAndMortyTCAApp.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickAndMortyTCAApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersListView(store: Store(initialState: CharactersListFeature.State(), reducer: {
                CharactersListFeature()
            }))
        }
    }
}
