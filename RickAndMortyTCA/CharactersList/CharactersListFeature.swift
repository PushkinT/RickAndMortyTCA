//
//  CharactersListFeature.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct CharactersListFeature {
    @Dependency(\.charactersAPI) var charactersAPI
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        // MARK: - Data states properties
        var characters: [RaMCharacter] = []
        
        // MARK: - Navigation states properties
        var path = StackState<CharacterDetailFeature.State>()
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        // MARK: - Data cases
        case fetchFirstCharacters
        case fetchNextCharacters
        case appendCharacters(characters: [RaMCharacter])
        
        // MARK: - Navigation cases
        case path(StackAction<CharacterDetailFeature.State, CharacterDetailFeature.Action>)
        
        // MARK: - Alert cases
        case alert(PresentationAction<Alert>)
        case showAlert(Error)
        
        // MARK: - Alert action cases
        enum Alert: Equatable {
            case hiddenError
        }
    }
    
    var body: some ReducerOf<CharactersListFeature> {
        Reduce { state, action in
            switch action {
                
                // MARK: - Run actions
            case .fetchFirstCharacters:
                return .run(priority: .userInitiated) { send in
                    let result = try await charactersAPI.getCharactersByPage(1)
                    await send(.appendCharacters(characters: result))
                } catch: { error, send in
                    await send(.showAlert(error))
                }
            case .fetchNextCharacters:
                return .run(priority: .userInitiated) { send in
                    let result = try await charactersAPI.getNextURLCharacters()
                    await send(.appendCharacters(characters: result))
                } catch: { error, send in
                    await send(.showAlert(error))
                }
                
                // MARK: - Data actions
            case let .appendCharacters(characters):
                state.characters.append(contentsOf: characters)
                return .none
                
                // MARK: - Alert actions
            case let .showAlert(error):
                state.alert = AlertState(title: {
                    TextState("Error")
                }, actions: {
                    ButtonState(role: .cancel,
                                action: .hiddenError) {
                        TextState("OK")
                    }
                }, message: {
                    TextState(error.localizedDescription)
                })
                return .none
            case .alert(.presented(.hiddenError)):
                return .run { send in
                    await self.dismiss()
                }
                
                // MARK: - Default actions
            case .path, .alert:
                return .none
            }
        }
        // MARK: - Navigation destinations
        .forEach(\.path, action: \.path) {
            CharacterDetailFeature()
        }
        // MARK: - Alerts destinations
        .ifLet(\.$alert, action: \.alert)
    }
}
