//
//  NetworkManager.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//
import Combine
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    init() {}

    func fetchCryptoCoins() -> AnyPublisher<[CryptoCoin], Error> {
        let url = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CryptoCoin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
