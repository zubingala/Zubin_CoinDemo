//
//  MockNetworkManager.swift
//  Zubin_CoinDemoTests
//
//  Created by Zubin Gala on 22/11/24.
//

import Combine
@testable import Zubin_CoinDemo

class MockNetworkManager: NetworkManager {
    
    var mockCoins: [CryptoCoin] = []

    override init() {
        super.init()
    }

    init(mockCoins: [CryptoCoin]) {
        super.init()
        self.mockCoins = mockCoins
    }

    override func fetchCryptoCoins() -> AnyPublisher<[CryptoCoin], Error> {
        return Just(mockCoins)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
