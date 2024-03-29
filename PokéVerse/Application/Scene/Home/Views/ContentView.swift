//
//  ContentView.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeViewModel = HomeViewModel()
    
    private let adaptiveColumuns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if homeViewModel.filterPokemon.isEmpty {
                    VStack(spacing: 12) {
                        Image("noResults")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                            .foregroundColor(UIColor.primaryColor)
                        Text("Sorry we couldn't find any results for your search.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }.padding(.top, 32)
                } else {
                    LazyVGrid(columns: adaptiveColumuns, spacing: 12) {
                        ForEach(homeViewModel.filterPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                PokemonImageView(pokemon: pokemon,
                                                 downloadUrl: homeViewModel.getImageUrl(pokemon: pokemon))
                            }
                        }
                    }.animation(.smooth(duration: 0.3),
                                value: homeViewModel.filterPokemon.count)
                    .navigationTitle("PokéVerse")
                    .alert(isPresented: $homeViewModel.showAlert) {
                        Alert(
                            title: Text("Something went wrong"),
                            message: Text(homeViewModel.errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    if homeViewModel.isLoading {
                        ProgressView()
                    }
                }
            }.searchable(text: $homeViewModel.searchText)
        }.environmentObject(homeViewModel)
            .accentColor(UIColor.primaryColor)
    }
}
