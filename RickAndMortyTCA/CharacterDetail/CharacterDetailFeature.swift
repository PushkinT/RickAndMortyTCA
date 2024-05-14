//
//  CharacterDetailFeature.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CharacterDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        var character: RaMCharacter
    }
    
    enum Action {
       // some actions
    }
}
