//
//  CryptoSearchFilterView.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import UIKit

protocol CryptoSearchFilterViewDelegate: AnyObject {
    func allAppliedFilters(filters: [AppConstants.CryptoSearchFilterOption]) -> [CryptoCoin]
}

class CryptoSearchFilterView: UIView {
    
    // MARK: - Properties
    let filterCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CryptoSearchFilterViewCell.self, forCellWithReuseIdentifier: "CryptoSearchFilterViewCell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
        
    } ()
    weak var delegate: CryptoSearchFilterViewDelegate?
    
    private let allFilters = AppConstants.CryptoSearchFilterOption.allCases
    private var selectedFilters: [AppConstants.CryptoSearchFilterOption] = []
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
     func setupUI() {
        // Configure collection view
         filterCollectionView.delegate = self
         filterCollectionView.dataSource = self
         addSubview(filterCollectionView)
         
         setupConstraints()
        
        
        // Set the background color for the filter view
        self.backgroundColor = .searchFilterBG
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            
            // Filter collection view is anchored with the super view with all 4 sides
            filterCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            filterCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            
        ])
    }
}

extension CryptoSearchFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CryptoSearchFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filterCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CryptoSearchFilterViewCell",
            for: indexPath
        ) as? CryptoSearchFilterViewCell else {
            return UICollectionViewCell()
        }
        
        let filter = allFilters[indexPath.row]
        let isSelected = selectedFilters.contains(filter)
        
        filterCell.setup(title: filter.rawValue, isSelected: isSelected)
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = allFilters[indexPath.row]
            
            // Toggle filter selection
            if let index = selectedFilters.firstIndex(of: selectedFilter) {
                selectedFilters.remove(at: index)
            } else {
                selectedFilters.append(selectedFilter)
            }
            
            // Reload the cell for updated state
            collectionView.reloadItems(at: [indexPath])
            
            // Notify delegate about applied filters
            if let filteredResults = delegate?.allAppliedFilters(filters: selectedFilters) {
                print("Filtered Results: \(filteredResults)")
            }
        
    }
}
