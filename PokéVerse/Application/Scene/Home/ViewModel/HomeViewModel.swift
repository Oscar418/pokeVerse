//
//  HomeViewModel.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

protocol HomeViewModelType {
    func getPokemons()
    func getImageUrl(pokemon: Pokemon) -> URL
}

final class HomeViewModel: ObservableObject, HomeViewModelType {
    private let pokeRepo: RestPokeRepository
    
    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    var filterPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter {
            $0.name.contains(searchText.lowercased())
        }
    }
    
    init(pokeRepo: RestPokeRepository = RestPokeRepository.shared) {
        self.pokeRepo = pokeRepo
        getPokemons()
    }
    
    func getPokemons() {
        isLoading = true
        pokeRepo.getPokemons() { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.pokemonList = data.results
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
}
