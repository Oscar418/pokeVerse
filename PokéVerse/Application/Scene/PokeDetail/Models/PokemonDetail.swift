//
//  PokemonDetail.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

struct PokemonDetail: Codable, Equatable {
    let id: Int
    let height: Int
    let weight: Int
    let stats: [PokeStat]
    let sprites: Sprite
}

struct PokeStat: Codable, Identifiable, Equatable {
    let id = UUID()
    let base_stat: Int
    let stat: Stat
}

struct Stat: Codable, Equatable {
    let name: String
}

struct Sprite: Codable, Equatable {
    let front_shiny: String
}
