//
//  CryptoListViewController.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import UIKit
import Combine

class CryptoListViewController: UIViewController, CryptoSearchFilterViewDelegate {
    
    private var tableView: UITableView = UITableView()
    private var searchBar: UISearchBar = UISearchBar()
    
    private let viewModel = CryptoListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var searchFilterView: CryptoSearchFilterView?
    private var bottomConstraint: NSLayoutConstraint?
    private var navigationTitleView: UILabel = {
        let label = UILabel()
        label.text = "Crypto Coin"
        label.textColor = .white
        label.textAlignment = .center
        return label
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMainStackView()
        setActivityLoader()
        setupUI()
        setupSearchBar()
        bindViewModel()
        viewModel.fetchCryptoCoins()
    }
    
    
    
    private func setupSearchBar() {
        
        searchBar.placeholder = "Search..."
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.delegate = self
        searchBar.alpha = 0
        customizeSearchBarAppearance()
        
    }
    
    private func customizeSearchBarAppearance() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.systemBlue
            textField.backgroundColor = .white
            textField.textColor = .black
        }
    }
    private func setupMainStackView() {
        
        setupTableView()
        let filterView = loadFilterView()
        let stackView = UIStackView(arrangedSubviews: [tableView, filterView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Add constraints with the super view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        
    }
    //MARK: - Set up navigation bar
    private func setupNavigationBar() {
        navigationItem.titleView = navigationTitleView
        
        // Search Button Item setup
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = searchButtonItem
        
        // Navigation Bar background color
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.systemIndigo
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
    }
    
    private func setupTableView() {
        tableView.register(CryptoCell.self, forCellReuseIdentifier: "CryptoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
    }
    
    private func loadFilterView() -> UIView  {
        let filterView = CryptoSearchFilterView(frame: .zero)
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return filterView
    }
    
    
    //MARK: - Loader setup
    private func setActivityLoader(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start the activity indicator (loading state)
        activityIndicator.startAnimating()
    }
    
    //MARK: - Model Binding
    private func bindViewModel() {
        
        // Reload tableView when filteredCoins changes
        viewModel.$filteredCoins
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] _ in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action Methods
    @objc private func searchButtonTapped() {
        
        if searchBar.alpha == 0 {
            navigationItem.titleView = searchBar
            searchBar.alpha = 1
        } else {
            searchBar.alpha = 0
            navigationItem.titleView = navigationTitleView
        }
        
        /*
         var isShowingAnimation = true
         let filterHeight = 120.0
         
         if searchFilterView?.isHidden ?? false {
         searchFilterView?.isHidden = false
         bottomConstraint?.constant = .zero
         } else {
         isShowingAnimation = false
         bottomConstraint?.constant = filterHeight
         }
         
         UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut) { [weak self] in
         self?.view.layoutIfNeeded()
         } completion: { [weak self] completed in
         if completed {
         var tableViewInsets = self?.tableView.contentInset
         if isShowingAnimation {
         tableViewInsets?.bottom = filterHeight
         } else {
         self?.searchFilterView?.isHidden = true
         tableViewInsets?.bottom = .zero
         }
         self?.tableView.contentInset = tableViewInsets ?? .zero
         }
         }
         */
    }
    
    func allAppliedFilters(filters: [AppConstants.CryptoSearchFilterOption]) -> [CryptoCoin] {
        viewModel.selectedFilters = filters
        viewModel.applyFiltersAndSearch(search: "", selectedFilters: filters)
        // Return the filtered coins (if needed elsewhere)
        return viewModel.filteredCoins
    }
    
}

// MARK: - Search Bar delegate methods
extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

//MARK: - UITableViewDelegate callback
extension CryptoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//MARK: - UITableViewDataSource callback
extension CryptoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoCell
        let coin = viewModel.filteredCoins[indexPath.row]
        
        cell.updateCell(with: CryptoCellViewModel(cryptoDetail: coin))
        
        return cell
    }
}

