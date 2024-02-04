//
//  UrlBuilderUtil.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

class UrlBuilderUtil {
    static func buildUrl(scheme: PokeNetworkConstants,
                         host: PokeNetworkConstants,
                         path: String,
                         queryItems: [URLQueryItem]? = [URLQueryItem]()) -> URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host.rawValue
        components.path = path
        
        if let queryItems = queryItems,
           queryItems.count > 0 {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else { return  nil }
        return url
    }
}
