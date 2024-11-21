//
//  AppConstants.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import Foundation

struct AppConstants{
    enum CryptoSearchFilterOption: String, CaseIterable {
        case activeCoins = "Active Coins"
        case inActiveCoins = "Inactive Coins"
        case onlyTokens = "Only Tokens"
        case onlyCoins = "Only Coins"
        case newCoins = "New Coins"
    }
}
