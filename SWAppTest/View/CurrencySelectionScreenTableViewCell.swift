//
//  CurrencySelectionScreenTableViewCell.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 25.08.2022.
//

import Foundation
import UIKit

class CurrencySelectionScreenTableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    private let nameCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
  
    
    private let charCodeCurrencyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let valueCurrencyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameCurrencyLabel)
        contentView.addSubview(charCodeCurrencyLabel)
        contentView.addSubview(valueCurrencyLabel)
        setupConstraints()
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            self.accessoryType = .none
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameCurrencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameCurrencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            nameCurrencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nameCurrencyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            charCodeCurrencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charCodeCurrencyLabel.bottomAnchor.constraint(equalTo: nameCurrencyLabel.topAnchor, constant: -20),
          
            valueCurrencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            valueCurrencyLabel.centerYAnchor.constraint(equalTo: nameCurrencyLabel.centerYAnchor),
            valueCurrencyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    public func configure(with model: Currensy) {
        nameCurrencyLabel.text = model.name
        charCodeCurrencyLabel.text = "(\(model.charCode))"
    }
    public func configureLoadingScreen(with model: Currensy) {
        nameCurrencyLabel.text = model.name
        charCodeCurrencyLabel.text = "(\(model.charCode))"
        valueCurrencyLabel.text = String(model.value) + "(RUB)"
    }
    
    
}
