//
//  CryptoSearchFilterViewCell.swift
//  Zubin_CoinDemo
//
//  Created by Zubin Gala on 21/11/24.
//

import UIKit

class CryptoSearchFilterViewCell: UICollectionViewCell {

    // MARK: - Properties
    private let btnTitle: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        self.backgroundColor = .searchFilterContent

        // Add and configure subviews
        hStackView.addArrangedSubview(btnTitle)
        contentView.addSubview(hStackView)

        // Set up constraints
        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            btnTitle.widthAnchor.constraint(equalTo: hStackView.widthAnchor)
        ])

        // Round corners
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    // MARK: - Public Methods
    func setup(title: String, isSelected: Bool) {
        btnTitle.setTitle(title, for: .normal)

        if isSelected {
            self.backgroundColor = .selectedSearchFilterContent
        } else {
            self.backgroundColor = .searchFilterContent
        }

        btnTitle.sizeToFit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
