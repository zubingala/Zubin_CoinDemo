//
//  CryptoListViewModelTests.swift
//  Zubin_CoinDemoTests
//
//  Created by Zubin Gala on 22/11/24.
//

import XCTest
import Combine
@testable import Zubin_CoinDemo

final class CryptoListViewModelTests: XCTestCase {
    
    var viewModel: CryptoListViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = CryptoListViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test: Verify fetchCryptoCoins() stores data in allCoins and filteredCoins
    func testFetchCryptoCoins() {
        let mockCoins: [CryptoCoin] = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin( name: "Ethereum", symbol: "ETH", type: "coin", isActive: true, isNew: true)
        ]
        
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockCoins = mockCoins
        
        viewModel.fetchCryptoCoins()
        
        XCTAssertEqual(viewModel.allCoins.count, 2)
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
    }
    
    // Test: Verify that filters are applied correctly
    func testApplyFiltersAndSearch() {
        let mockCoins: [CryptoCoin] = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: false, isNew: true),
            CryptoCoin(name: "Shiba Inu", symbol: "SHIB", type: "token", isActive: true, isNew: true)
        ]
        viewModel.allCoins = mockCoins
        
        viewModel.selectedFilters = [.activeCoins]
        
        viewModel.applyFiltersAndSearch(search: "", selectedFilters: viewModel.selectedFilters)
        
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
        
        viewModel.applyFiltersAndSearch(search: "shiba", selectedFilters: viewModel.selectedFilters)
        
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Shiba Inu")
    }
    
    // Test: Verify search behavior when no filters are applied
    func testSearchWithoutFilters() {
        let mockCoins: [CryptoCoin] = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: false, isNew: true),
            CryptoCoin(name: "Shiba Inu", symbol: "SHIB", type: "token", isActive: true, isNew: true)
        ]
        viewModel.allCoins = mockCoins
        
        viewModel.applyFiltersAndSearch(search: "bitcoin", selectedFilters: [])
        
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    // Test: Verify selected filters are applied properly with multiple filters
    func testMultipleFilters() {
        let mockCoins: [CryptoCoin] = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: true, isNew: true),
            CryptoCoin(name: "Shiba Inu", symbol: "SHIB", type: "token", isActive: true, isNew: true)
        ]
        viewModel.allCoins = mockCoins
        viewModel.selectedFilters = [.activeCoins, .onlyTokens]
        
        viewModel.applyFiltersAndSearch(search: "", selectedFilters: viewModel.selectedFilters)
        
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Shiba Inu")
    }
}
