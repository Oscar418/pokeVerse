//
//  Pokemon.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
}
