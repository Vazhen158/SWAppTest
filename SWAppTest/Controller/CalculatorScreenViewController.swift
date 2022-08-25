//
//  CalculatorScreenViewController.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 25.08.2022.
//

import Foundation
import UIKit


class CalculatorScreenViewController: UIViewController {
    
    private let fromCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private let toCurrencyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let currencySelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Currency selection", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(currencySelectionPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private var fromCurrencyTextField = CurrencyTextField()
    private var toCurrencyTextField = CurrencyTextField()
    
    var fromCurrency = Currensy(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    var toCurrency  = Currensy(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сurrency rate calculator"
        view.backgroundColor = .white
        view.addSubview(fromCurrencyLabel)
        view.addSubview(toCurrencyLabel)
        view.addSubview(fromCurrencyTextField)
        view.addSubview(toCurrencyTextField)
        view.addSubview(currencySelectionButton)
        
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromCurrencyTextField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
        toCurrencyTextField.addTarget(self, action: #selector(updateViewsTwo), for: .editingChanged)
    }
    
    @objc func currencySelectionPress() {
        let selectionVC = CurrencySelectionScreenViewController()
        selectionVC.fromSelectionDelegate = self
        selectionVC.toSelectionDelegate = self
        self.present(selectionVC, animated: true, completion: nil)
    }
    
    @objc func updateViews() {
        guard let amountText = fromCurrencyTextField.text, let theAmountText = Double(amountText) else {return}
        if fromCurrencyTextField.text != "" {
            let total = theAmountText * fromCurrency.value / toCurrency.value
            toCurrencyTextField.text = String(format: "%.2f", total)
        }
    }
    
    @objc func updateViewsTwo() {
        guard let amountText = toCurrencyTextField.text, let theAmountText = Double(amountText) else {return}
        if toCurrencyTextField.text != "" {
            let total = theAmountText * toCurrency.value / fromCurrency.value
            fromCurrencyTextField.text = String(format: "%.2f", total)
        }
    }
    
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            fromCurrencyLabel.centerYAnchor.constraint(equalTo: fromCurrencyTextField.centerYAnchor),
            fromCurrencyLabel.trailingAnchor.constraint(equalTo: fromCurrencyTextField.leadingAnchor, constant: -10),
            fromCurrencyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            fromCurrencyLabel.topAnchor.constraint(equalTo: fromCurrencyTextField.topAnchor, constant: 0),
            
            fromCurrencyTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fromCurrencyTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            fromCurrencyTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            fromCurrencyTextField.heightAnchor.constraint(equalToConstant: 60),
            
            toCurrencyLabel.centerYAnchor.constraint(equalTo: toCurrencyTextField.centerYAnchor),
            toCurrencyLabel.trailingAnchor.constraint(equalTo: toCurrencyTextField.leadingAnchor, constant: -10),
            toCurrencyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            toCurrencyLabel.topAnchor.constraint(equalTo: toCurrencyTextField.topAnchor, constant: 0),
                        
            toCurrencyTextField.topAnchor.constraint(equalTo: fromCurrencyTextField.bottomAnchor, constant: 30),
            toCurrencyTextField.widthAnchor.constraint(equalTo: fromCurrencyTextField.widthAnchor),
            toCurrencyTextField.heightAnchor.constraint(equalToConstant: 60),
            toCurrencyTextField.centerXAnchor.constraint(equalTo: fromCurrencyTextField.centerXAnchor, constant: 0),
                        
            currencySelectionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            currencySelectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencySelectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            currencySelectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            currencySelectionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
        ])
  
    }

}

extension CalculatorScreenViewController: FromSelectionDelegate {
    func didSelectFrom(currencies: Currensy?) {
        guard let currency = currencies else {return}
        fromCurrencyLabel.text = "From: " + currency.charCode
        fromCurrency = currency
    }
    
}

extension CalculatorScreenViewController: ToSelectionDelegate {
    func didSelectTo(currencies: Currensy?) {
        guard let currency = currencies else {return}
        toCurrencyLabel.text = "To: " + currency.charCode
        toCurrency = currency
    }
    
    
}
