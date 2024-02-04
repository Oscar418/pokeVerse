//
//  DetailViewModel.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

protocol DetailViewModelType {
    func getDetails(pokemon: Pokemon)
    func getImageUrl(pokemon: Pokemon) -> URL
    func formatNumber(value: Int) -> String
}

final class DetailViewModel: ObservableObject, DetailViewModelType {
    private let pokeRepo: RestPokeRepository
    
    @Published var pokemonDetails: PokemonDetail?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init(pokeRepo: RestPokeRepository = RestPokeRepository.shared) {
        self.pokeRepo = pokeRepo
    }
    
    func getDetails(pokemon: Pokemon) {
        guard let id = Int(LinkUtils.getLastPath(fromUrl: pokemon.url)) else { 
            self.showAlert = true
            self.errorMessage = "Failed to get character id"
            return
        }
        isLoading = true
        pokeRepo.getDetailedPokemon(id: id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.pokemonDetails = data
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = true
                self.errorMessage = error
            }
        }
    }
    
    func getImageUrl(pokemon: Pokemon) -> URL {
        guard let downloadImageUrl = UrlBuilderUtil.buildUrl(scheme: .scheme,
                                                             host: .imageHost,
                                                             path: "\(PokeNetworkConstants.spritesPath.rawValue)\(LinkUtils.getLastPath(fromUrl: pokemon.url))\(ImageExtension.png.rawValue)") else { return URL(string: "")! }
        return downloadImageUrl
    }
    
    func formatNumber(value: Int) -> String {
        MeasurementsUtil.formatNumber(value: value,
                                      factor: 10)
    }
}
