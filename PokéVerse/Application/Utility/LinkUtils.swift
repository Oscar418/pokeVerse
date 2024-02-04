//
//  LinkUtils.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

class LinkUtils {
    static func getLastPath(fromUrl urlString: String) -> String {
        guard let url = URL(string: urlString) else { return "" }
        let lastPathComponent = url.lastPathComponent
        return lastPathComponent
    }
}
