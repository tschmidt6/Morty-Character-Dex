//
//  CharacterAPIService.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/26/25.
//

import Foundation
import Combine

protocol APIClient {
    func fetchCharacters(url: URL) -> AnyPublisher<[RMCharacter], Error>
}

class CharacterAPIService: APIClient {
    private let session: URLSession
    
    // Enum to represent specific errors
    public enum ServiceError: Swift.Error {
        case connectivity
        case invalidData
        case unexpectedValues
        case serverError(statusCode: Int)
        case decodingError
    }
    
    struct CharacterAPIResponse: Decodable {
        let results: [RMCharacter]
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCharacters(url: URL) -> AnyPublisher<[RMCharacter], Swift.Error> {
         session.dataTaskPublisher(for: url)
             .tryMap { data, response in
                 guard let httpResponse = response as? HTTPURLResponse else {
                     throw ServiceError.unexpectedValues
                 }

                 if (200...299).contains(httpResponse.statusCode) {
                     do {
                         // Attempt to map the Json data to [RMCharacter]
                         return try JSONDecoder().decode(CharacterAPIResponse.self, from: data).results
                     } catch {
                         throw ServiceError.decodingError
                     }
                 } else {
                     throw ServiceError.serverError(statusCode: httpResponse.statusCode)
                 }
             }
             .mapError { error -> Swift.Error in
                 // Map other errors to custom ServiceError
                 switch error {
                 case is URLError:
                     return ServiceError.connectivity
                 case is DecodingError:
                     return ServiceError.decodingError
                 case let error as ServiceError:
                     return error
                 default:
                     return ServiceError.invalidData
                 }
             }
             .eraseToAnyPublisher()
     }
}
