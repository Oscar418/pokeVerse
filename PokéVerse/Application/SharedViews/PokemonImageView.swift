//
//  PokemonImageView.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

struct PokemonImageView: View {
    @StateObject var viewModel = DetailViewModel()
    
    let pokemon: Pokemon
    let downloadUrl: URL
    let size: Double = 150
    
    var body: some View {
        VStack {
            AsyncImage(url: downloadUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size,
                           height: size)
                    .padding(8)
            } placeholder: {
                ProgressView()
                    .frame(width: size,
                           height: size)
            }
            .background(UIColor.primaryColor)
            .clipShape(Circle())
            
            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 18,
                              weight: .regular,
                              design: .monospaced))
                .padding(.bottom, 20)
                .foregroundColor(Color.black)
        }.environmentObject(viewModel)
    }
}
