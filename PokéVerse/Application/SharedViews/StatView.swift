//
//  StatView.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import SwiftUI

struct StatView: View {
    
    let pokemonStat: [PokeStat]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(pokemonStat) { stat in
                    VStack(spacing: 2) {
                        Text("\(stat.stat.name)")
                            .font(.system(size: 14,
                                          weight: .light,
                                          design: .monospaced))
                            .foregroundColor(.white)
                        Text("\(stat.base_stat)")
                            .font(.system(size: 14,
                                          weight: .semibold,
                                          design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(UIColor.primaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

//#Preview {
//    StatView()
//}
