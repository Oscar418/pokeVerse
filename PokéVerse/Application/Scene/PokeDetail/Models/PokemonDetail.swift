//
//  PokemonDetail.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let stats: [PokeStat]
    let sprites: Sprite
}

struct PokeStat: Codable, Identifiable {
    let id = UUID()
    let base_stat: Int
    let stat: Stat
}

struct Stat: Codable {
    let name: String
}

struct Sprite: Codable {
    let front_shiny: String
}
