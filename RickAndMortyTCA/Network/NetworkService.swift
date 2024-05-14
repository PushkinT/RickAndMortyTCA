//
//  NetworkService.swift
//  RickAndMortyTCA
//
//  Created by Taras Pushkar on 14.05.2024.
//

import Foundation
import Dependencies

fileprivate enum NetworkErrors: Error {
    case badURL
    case badStatusCode
}

fileprivate enum APIUrl {
    static private let baseURL = "https://rickandmortyapi.com/api/"
    
    case getCharactersByPage(number: Int)
    case getCharacterByID(id: Int)
    case getAllCharacters
    
    var url: String {
        switch self {
        case .getCharactersByPage(number: let number):
            Self.baseURL + "character/" + "?page=" + "\(number)"
        case .getCharacterByID(id: let id):
            Self.baseURL + "character/" + "\(id)"
        case .getAllCharacters:
            Self.baseURL + "character"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchData(for urlString: String) async throws -> Data
}

struct NetworkService: NetworkServiceProtocol {
    func fetchData(for urlString: String) async throws -> Data {
        guard let validURL = URL(string: urlString) else { throw NetworkErrors.badURL }
        
        let (data, responce) = try await URLSession.shared.data(from: validURL)
        
        guard let statusCode = (responce as? HTTPURLResponse)?.statusCode,
              200..<299 ~= statusCode else { throw NetworkErrors.badStatusCode }
        
        return data
    }
}

struct CharactersAPI {
    
    // MARK: - Info
    struct Info: Decodable {
        let count, pages: Int
        let next: String?
    }

    // MARK: - CraractersArray
    struct CraractersArray: Decodable {
        let info: Info
        let results: [RaMCharacter]
    }
    
    private static let networkSevice: NetworkServiceProtocol = NetworkService()
    private static var nextPageURLString: String?
    
    var getCharactersByPage: (Int) async throws -> [RaMCharacter]
    var getNextURLCharacters: () async throws -> [RaMCharacter]
}

extension CharactersAPI: DependencyKey {
    static  let liveValue: CharactersAPI = CharactersAPI(
        getCharactersByPage: { pageNumber in
            let data = try await Self.networkSevice.fetchData(for: APIUrl.getCharactersByPage(number: pageNumber).url)
            let charactersResult: CraractersArray = try JSONDecoder().decode(CraractersArray.self, from: data)
            nextPageURLString = charactersResult.info.next

            return charactersResult.results
        },
        getNextURLCharacters: {
            guard let nextPageURLString else { return [] }
            
            let data = try await networkSevice.fetchData(for: nextPageURLString)
            let charactersResult: CraractersArray = try JSONDecoder().decode(CraractersArray.self, from: data)
            Self.nextPageURLString = charactersResult.info.next
            
            return charactersResult.results
        })
}

// MARK: - DependencyValues
extension DependencyValues {
    var charactersAPI: CharactersAPI {
        get { self[CharactersAPI.self] }
        set { self[CharactersAPI.self] = newValue }
    }
}

