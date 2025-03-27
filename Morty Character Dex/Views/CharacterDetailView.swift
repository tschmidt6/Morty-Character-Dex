//
//  CharacterDetailView.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/26/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(character.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
           
            
            VStack(alignment: .leading, spacing: 8) {
                // Character Details
                HStack {
                    Text("Species: ").font(.headline)
                    Text("\(character.species)").font(.body)
                }
                HStack {
                    Text("Status: ").font(.headline)
                    Text("\(character.status)").font(.body)
                }
                HStack {
                    Text("Origin: ").font(.headline)
                    Text("\(character.origin.name)").font(.body)
                }

                if let type = character.type, !type.isEmpty {
                    HStack {
                        Text("Type: ").font(.headline)
                        Text("\(type)").font(.body)
                    }
                }

                if let formattedDate = formatDate(character.created) {
                    HStack {
                        Text("Created: ").font(.headline)
                        Text("\(formattedDate)").font(.body)
                    }
                }
            }.padding(.horizontal)
            Spacer()
        }
    }
    
    // Function to Format the Date
    func formatDate(_ isoDate: String) -> String? {
        if let date = ISO8601DateFormatter.isoFormatter.date(from: isoDate) {
            return DateFormatter.displayFormatter.string(from: date)
        }
        return nil
    }
}

#Preview {
    CharacterDetailView(character: RMCharacter(id: 0, name: "Rick", species: "Human", status: "Alive", type: "", origin: Origin(name: "Earth (C-137)"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", created: "2017-11-04T18:48:46.250Z"))
}

// MARK: - Date Formatting
extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ISO8601DateFormatter {
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
