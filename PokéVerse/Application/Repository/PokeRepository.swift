//
//  PokeRepository.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

protocol PokeRepository {
    func getPokemons(completion: @escaping (PokemonResults) -> Void, failure: @escaping (String) -> Void)
    func getDetailedPokemon(id: Int, completion: @escaping (PokemonDetail) -> Void, failure: @escaping (String) -> Void)
}

final class RestPokeRepository: PokeRepository {
    static let shared = RestPokeRepository()
    
    private let network: Network
    
    init(network: Network = Network.shared) {
        self.network = network
    }
    
    func getPokemons(completion: @escaping (PokemonResults) -> Void,
                     failure: @escaping (String) -> Void) {
        guard let url = UrlBuilderUtil.buildUrl(scheme: .scheme,
                                                host: .pokeHost,
                                                path: PokeNetworkConstants.pokemonPath.rawValue,
                                                queryItems: [URLQueryItem(name: "limit", value: "100")]) else {
            failure("url unrecognized")
            return
        }
        network.fetchData(url: url,
                          model: PokemonResults.self) { data in
            completion(data)
        } failure: { error in
            failure(error.localizedDescription)
        }
    }
    
    func getDetailedPokemon(id: Int,
                            completion: @escaping (PokemonDetail) -> Void,
                            failure: @escaping (String) -> Void) {
        guard let url = UrlBuilderUtil.buildUrl(scheme: .scheme,
                                                host: .pokeHost,
                                                path: PokeNetworkConstants.pokemonPath.rawValue + "/\(id)") else {
            failure("url unrecognized")
            return
        }
        network.fetchData(url: url,
                          model: PokemonDetail.self) { data in
            completion(data)
        } failure: { error in
            failure(error.localizedDescription)
        }
    }
}
