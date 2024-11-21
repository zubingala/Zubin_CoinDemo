//
//  CryptoListViewModel.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import Foundation
import Combine

class CryptoListViewModel {
    //MARK: - PROPERTIES
    @Published var selectedFilters: [AppConstants.CryptoSearchFilterOption] = []
    @Published private(set) var filteredCoins: [CryptoCoin] = []
    @Published var searchText: String = ""
    @Published var filters: [String: Bool] = [:]
    
    var allCoins: [CryptoCoin] = []
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - INIT
    init() {
        Publishers.CombineLatest($searchText, $selectedFilters)
            .sink { [weak self] search, selectedFilters in
                self?.applyFiltersAndSearch(search: search, selectedFilters: selectedFilters)
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: - FETCH COINS
    func fetchCryptoCoins() {
        NetworkManager.shared.fetchCryptoCoins()
        
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error fetching data: \(error)")
                    }
                },
                receiveValue: { [weak self] coins in
                    self?.allCoins = coins
                    self?.filteredCoins = coins
                }
            )
            .store(in: &cancellables)
    }
    
    
    //MARK: - FILTER AND SEARCH
    func applyFiltersAndSearch(search: String, selectedFilters: [AppConstants.CryptoSearchFilterOption]) {
        filteredCoins = allCoins.filter { coin in
            
            var matches = true
            
            for filter in selectedFilters {
                switch filter {
                case .activeCoins:
                    matches = matches && coin.isActive
                case .inActiveCoins:
                    matches = matches && !coin.isActive
                case .onlyTokens:
                    matches = matches && coin.type.lowercased() == "token"
                case .onlyCoins:
                    matches = matches && coin.type.lowercased() == "coin"
                case .newCoins:
                    matches = matches && coin.isNew
                }
                
                if !matches { break }
            }
            
            // Search Logic
            let searchMatches = search.isEmpty ||
            coin.name.lowercased().contains(search.lowercased()) ||
            coin.symbol.lowercased().contains(search.lowercased())
            matches = matches && searchMatches
            print("Search Matches: \(searchMatches)")
            
            return matches
        }
    }
}
