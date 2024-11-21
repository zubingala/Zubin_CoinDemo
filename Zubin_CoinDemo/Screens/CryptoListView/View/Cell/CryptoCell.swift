//
//  CryptoCell.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import UIKit

class CryptoCell: UITableViewCell {
    
    // MARK: - Views Initialization
    let freshnessImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NewCrypto")
        return imageView
        
    } ()
    
    let cryptoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ActiveCoin")
        return imageView
        
    }()
    
    let containerView: UIView = {
       
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
        
    }()
    
    let cryptoName: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .systemGray2
        label.text = "Bitcoin"
        return label
        
    } ()
    
    let cryptoAcronym: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        label.textColor = .systemGray
        label.text = "BTC"
        return label
        
    } ()
    
    let cryptoTextStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    } ()
    
    let mainStackView: UIStackView = {
            
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    } ()
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        backgroundColor = .clear
        contentView.addSubview(containerView)
        
        setupCryptoTextStackView()
        setupMainStackView()
        setupFreshnessImageView()
        
        containerView.addSubview(mainStackView)
        
        setupConstraints()
        
    }
    
    private func setupFreshnessImageView() {
        containerView.addSubview(freshnessImageView)
    }
    
    private func setupMainStackView() {
        
        mainStackView.addArrangedSubview(cryptoTextStackView)
        mainStackView.addArrangedSubview(cryptoImageView)
        
    }
    
    private func setupCryptoTextStackView() {
        
        cryptoTextStackView.addArrangedSubview(cryptoName)
        cryptoTextStackView.addArrangedSubview(cryptoAcronym)
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            // Container View constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Main stack view constraint
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // Crypto Image View Constraint
            cryptoImageView.widthAnchor.constraint(equalToConstant: 70),
            
            //freshness Image view constraint
            freshnessImageView.widthAnchor.constraint(equalToConstant: 30),
            freshnessImageView.heightAnchor.constraint(equalToConstant: 30),
            freshnessImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            freshnessImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        ])
        
    }
    
    // MARK: - UI Updation
    func updateCell(with viewModel: CryptoCellViewModel) {
        freshnessImageView.isHidden = viewModel.isFreshnessImageViewHidden
        cryptoImageView.image = UIImage(named: viewModel.cryptoImageName)
        cryptoName.text = viewModel.cryptoName
        cryptoAcronym.text = viewModel.cryptoAcronym
    }
}

