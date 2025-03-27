//
//  CharacterListView.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/26/25.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel = CharacterListViewModel(characterAPIService: CharacterAPIService())
    
    var body: some View {
        NavigationStack {
            VStack {
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                // Display characters in a List
                List(viewModel.rmCharacters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        HStack {
                            // Character Image
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            
                            VStack(alignment: .leading) {
                                // Character Name
                                Text(character.name)
                                    .font(.headline)
                                
                                // Character Species
                                Text(character.species)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .searchable(text: $viewModel.searchText, prompt: "Search Rick & Morty Characters")
                .onChange(of: viewModel.searchText) { oldValue, newValue in
                    viewModel.fetchCharacters(for: newValue.lowercased())
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Rick & Morty Dex")
            }
        }
    }
}

#Preview {
    CharacterListView()
}
