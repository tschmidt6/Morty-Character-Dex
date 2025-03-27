//
//  CharacterAPIServiceSpy.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/27/25.
//


import Foundation
import Combine
import XCTest

@testable import Morty_Character_Dex

class CharacterAPIServiceSpy: APIClient {
    private var messages = [(url: URL, subject: PassthroughSubject<[Morty_Character_Dex.RMCharacter], Error>)]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func fetchCharacters(url: URL) -> AnyPublisher<[Morty_Character_Dex.RMCharacter], any Error> {
        let subject = PassthroughSubject<[Morty_Character_Dex.RMCharacter], Error>()
        messages.append((url, subject))
        return subject.eraseToAnyPublisher()
    }
    
    func complete(with error: Error, at index: Int = 0) {
        guard messages.count > index else {
            return XCTFail("Can't complete request never made")
        }
        
        messages[index].subject.send(completion: .failure(error))
    }
    
    func complete(withStatusCode code: Int, data: [Morty_Character_Dex.RMCharacter], at index: Int = 0) {
        guard requestedURLs.count > index else {
            return XCTFail("Can't complete request never made")
        }
        
        messages[index].subject.send((data))
        messages[index].subject.send(completion: .finished)
    }
}
