//
//  Morty_Character_DexTests.swift
//  Morty Character DexTests
//
//  Created by Teryl S on 3/26/25.
//

import Foundation
import XCTest
import Combine

@testable import Morty_Character_Dex

class Morty_Character_DexTests: XCTestCase {

    func test_fetchCharacters_deliversConnectivityError_displaysToUser() {
        // Given
        let client = CharacterAPIServiceSpy()
        let sut = CharacterListViewModel(characterAPIService: client)

        // Create an expectation for the error
        let expectation = self.expectation(description: "Wait for error message")
        
        // When: Trigger the fetch
        sut.fetchCharacters(for: "rick")
        
        // Subscribe to error message updates
        var receivedErrorMessage: String?
        let cancellable = sut.$errorMessage
            .compactMap { $0 }
            .first()
            .sink { errorMessage in
                receivedErrorMessage = errorMessage
                expectation.fulfill()
            }
        
        client.complete(with: CharacterAPIService.ServiceError.connectivity, at: 0)
        
        // Wait for expectation
        waitForExpectations(timeout: 1)
        cancellable.cancel()

        // Then: Verify that the error message is correctly set
        XCTAssertEqual(receivedErrorMessage, "There was a problem connecting to the server. Please check your internet connection.")
    }
    
    func test_fetchCharacters_deliversCorrectData() {
        // Given
        let client = CharacterAPIServiceSpy()
        let sut = CharacterListViewModel(characterAPIService: client)
        
        // Create an expectation for the async error update
        let expectation = self.expectation(description: "Wait for characters to download")
        var expectationFulfilled = false
        
        // When: Trigger the fetch
        sut.fetchCharacters(for: "rick")
        
        // Subscribe to character array updates
        var receivedCharacters: [RMCharacter] = []
        let cancellable = sut.$rmCharacters
            .compactMap { $0 }
            .sink { characters in
                if !expectationFulfilled, !characters.isEmpty {
                    receivedCharacters = characters
                    expectation.fulfill()
                    expectationFulfilled = true
                }
            }
        
        // Simulate the API response
        let dummyCharacters = JsonDummyData()
        client.complete(withStatusCode: 200, data: dummyCharacters, at: 0)
        
        // Wait for expectation
        waitForExpectations(timeout: 1)
        cancellable.cancel()

        // Then: Verify that the characters array is correctly set
        XCTAssertEqual(receivedCharacters.count, dummyCharacters.count)
        XCTAssertEqual(receivedCharacters.first?.name, "Rick Sanchez")
        XCTAssertEqual(receivedCharacters[2].name, "Summer Smith")
    }
    
    func test_fetchCharacter_doesNotDeliverResultsAfterDeallocated() {
        // Given
        let client = CharacterAPIServiceSpy()
        var sut: CharacterListViewModel? = CharacterListViewModel(characterAPIService: client)
        
        // When: Trigger the fetch
        sut?.fetchCharacters(for: "rick")
        
        // Subscribe to character array updates
        var receivedCharacters: [RMCharacter] = []
        let cancellable = sut?.$rmCharacters
            .sink { characters in
                receivedCharacters = characters
            }
            
        
        // Deallocate the ViewModel before the request completes
        sut = nil
        
        // Simulate the API response
        let dummyCharacters = JsonDummyData()
        client.complete(withStatusCode: 200, data: dummyCharacters, at: 0)
        cancellable?.cancel()
        
        // Then: Verify that no results were not delivered after deallocation
        XCTAssertTrue(receivedCharacters.isEmpty, "Results should not be delivered after deallocation.")
    }
    
    func JsonDummyData() -> [RMCharacter] {
        return [
            RMCharacter(id: 0, name: "Rick Sanchez", species: "Human", status: "Alive", type: "", origin: Origin(name: "Earth (C-137)"), image: "rick_image_url", created: "2013-12-02T00:00:00.000Z"),
            RMCharacter(id: 1, name: "Morty Smith", species: "Human", status: "Alive", type: "", origin: Origin(name: "unknown"), image: "morty_image_url", created: "2013-12-02T00:00:00.000Z"),
            RMCharacter(id: 2, name: "Summer Smith", species: "Human", status: "Alive", type: "", origin: Origin(name: "cronenberg Earth"), image: "summer_image_url", created: "2013-12-02T00:00:00.000Z"),
            RMCharacter(id: 3, name: "Beth Smith", species: "Human", status: "Alive", type: "", origin: Origin(name: "unknown"), image: "beth_image_url", created: "2013-12-02T00:00:00.000Z"),
            RMCharacter(id: 4, name: "Jerry Smith", species: "Human", status: "Alive", type: "", origin: Origin(name: "unknown"), image: "jerry_image_url", created: "2013-12-02T00:00:00.000Z")
            ]
    }

}
