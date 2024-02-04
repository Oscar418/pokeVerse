//
//  PokemonDetailView.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var pokeDetailsViewModel = DetailViewModel()
    
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            if let url = URL(string: pokeDetailsViewModel.pokemonDetails?.sprites.front_shiny ?? "") {
                PokemonImageView(pokemon: pokemon,
                                 downloadUrl: url)
            }
            
            VStack(spacing: 12) {
                Text("**Weight**: \(pokeDetailsViewModel.formatNumber(value: pokeDetailsViewModel.pokemonDetails?.weight ?? 0)) KG")
                Text("**Height**: \(pokeDetailsViewModel.formatNumber(value: pokeDetailsViewModel.pokemonDetails?.height ?? 0)) M")
            }.alert(isPresented: $pokeDetailsViewModel.showAlert) {
                Alert(
                    title: Text("Something went wrong"),
                    message: Text(pokeDetailsViewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            if pokeDetailsViewModel.isLoading {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text("Stats:")
                    .font(.system(size: 18,
                                  weight: .semibold,
                                  design: .serif))
                StatView(pokemonStat: pokeDetailsViewModel.pokemonDetails?.stats ?? [PokeStat]())
            }.padding(.horizontal, 12)
                .padding(.top, 16)
            Spacer()
        }.onAppear {
            pokeDetailsViewModel.getDetails(pokemon: pokemon)
        }.environmentObject(pokeDetailsViewModel)
    }
}
