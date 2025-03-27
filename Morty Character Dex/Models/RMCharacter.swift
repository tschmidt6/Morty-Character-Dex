//
//  RMCharacter.swift
//  Morty Character Dex
//
//  Created by Teryl S on 3/27/25.
//

import Foundation

struct RMCharacter: Codable, Identifiable {
    let id: Int
    let name: String
    let species: String
    let status: String
    let type: String?
    let origin: Origin
    let image: String
    let created: String
}

struct Origin: Codable {
    let name: String
}
