//
//  PokemonResults.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

struct PokemonResults: Codable {
    let count: Int
    let next: String
    let results: [Pokemon]
}
