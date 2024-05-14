//
//  RaMCharacter.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import Foundation

// MARK: - RaMCharacter
struct RaMCharacter: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
