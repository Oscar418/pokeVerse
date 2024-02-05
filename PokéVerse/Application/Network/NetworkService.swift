//
//  NetworkService.swift
//  PokéVerse
//
//  Created by Ndamu Nengovhela on 2024/02/03.
//

import Foundation

final class Network {
    static let shared = Network()
    
    func fetchData<T: Decodable>(url: URL,
                                 model: T.Type,
                                 completion: @escaping(T) -> (),
                                 failure: @escaping(Error) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    failure(error)
                } else {
                    let defaultError = NSError(domain: "",
                                               code: 1,
                                               userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                    failure(defaultError)
                }
                return
            }
            
            do {
                let serverData = try JSONDecoder().decode(T.self,
                                                          from: data)
                completion(serverData)
            } catch {
                failure(error)
            }
        }.resume()
    }
}
