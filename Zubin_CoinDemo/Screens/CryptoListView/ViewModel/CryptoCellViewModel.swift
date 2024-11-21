//
//  CryptoCellViewModel.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import Foundation

enum CryptoType: String {
    case activeCoin = "coin"
    case activeToken = "token"
    
    var getImageName: String {
        switch self {
        case .activeCoin:
            return "ActiveCoin"
        case .activeToken:
            return "ActiveToken"
        }
    }
}

class CryptoCellViewModel {
    
    private var cryptoDetail: CryptoCoin
    
    init(cryptoDetail: CryptoCoin) {
        self.cryptoDetail = cryptoDetail
    }
    
    var isFreshnessImageViewHidden: Bool {
        return !cryptoDetail.isNew
    }
    
    var cryptoImageName: String {
        guard let cryptoType = CryptoType(rawValue: cryptoDetail.type) else {
            return cryptoDetail.isActive ? "bitcoinsign.circle.fill" : "InactiveCrypto"
        }
        return cryptoDetail.isActive ? cryptoType.getImageName : "InactiveCrypto"
    }
    
    var cryptoName: String {
        return cryptoDetail.name
    }
    
    var cryptoAcronym: String {
        return cryptoDetail.symbol
    }
}

