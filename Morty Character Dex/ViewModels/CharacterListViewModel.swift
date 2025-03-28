//
//  CharacterSearchViewModel.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/26/25.
//

import SwiftUI
import Combine

class CharacterListViewModel: ObservableObject {
    @Published var rmCharacters: [RMCharacter] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = ""
    
    private let characterAPIService: APIClient
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(characterAPIService: APIClient) {
        self.characterAPIService = characterAPIService
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main) // Wait 500ms after typing
            .removeDuplicates() // Prevent duplicate requests
            .filter { !$0.isEmpty } // Only proceed if the search text is not empty
            .sink { [weak self] searchText in
                self?.fetchCharacters(for: searchText)
            }
            .store(in: &cancellables)
    }

    func fetchCharacters(for searchText: String) {
        guard !searchText.isEmpty else {
            rmCharacters = []
            return
        }
        errorMessage = nil
        isLoading = true

        let searchURL = URL(string: "https://rickandmortyapi.com/api/character/?name=\(searchText)")!
        
        characterAPIService.fetchCharacters(url: searchURL)
            .receive(on: DispatchQueue.main)  // Ensure UI updates happen on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = self?.getErrorMessage(from: error)
                    self?.rmCharacters = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] characters in
                self?.rmCharacters = characters
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    // Helper function to convert error to a readable message
        private func getErrorMessage(from error: Error) -> String {
            switch error {
            case CharacterAPIService.ServiceError.connectivity:
                return "There was a problem connecting to the server. Please check your internet connection."
            case CharacterAPIService.ServiceError.decodingError:
                return "There was an issue processing the data. Please try again later."
            case CharacterAPIService.ServiceError.serverError(let statusCode):
                return "Status code: \(statusCode). That character is not in the database."
            case CharacterAPIService.ServiceError.unexpectedValues:
                return "Unexpected data received. Please try again later."
            default:
                return "An unknown error occurred. Please try again."
            }
        }
}
