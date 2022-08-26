//
//  StartLoadingScreenViewController.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import Foundation
import UIKit

class StartLoadingScreenViewController: UIViewController {
    
    private var currencies: [Currensy]?
    
    private let url = "https://www.cbr.ru/scripts/XML_daily.asp"
    private var fromCurrency = Currensy(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    
    
    private var conteinerView:  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    public let startScreenTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencySelectionScreenTableViewCell.self, forCellReuseIdentifier: CurrencySelectionScreenTableViewCell.identifier)
        return table
    }()
    
    private let currencyConverterButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setBackgroundImage(UIImage(named: "arrow"), for: .normal)
        button.titleLabel?.text = "Converter"
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(currencyConverterPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let favoritesCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "star"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.titleLabel?.text = "favorites"
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(favoritesCurrencyPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Exchange Rates"
        view.backgroundColor = .white
        view.addSubview(conteinerView)
        view.addSubview(currencyConverterButton)
        view.addSubview(favoritesCurrencyButton)
        conteinerView.addSubview(startScreenTableView)
        setConstraint()
        currencyTableConfigure()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startScreenTableView.frame = conteinerView.bounds
    }
    
    private func currencyTableConfigure() {
        startScreenTableView.delegate = self
        startScreenTableView.dataSource = self
    }
    
    private func fetchData() {
        let parser = CurrensyParser()
        parser.parseСurrencies(url: url) { (currensies) in
            self.currencies = currensies
            self.currencies?.append(self.fromCurrency)
            DispatchQueue.main.async {
                self.startScreenTableView.reloadData()
            }
        }
    }
    
    @objc func currencyConverterPress() {
        self.navigationController?.pushViewController(CalculatorScreenViewController(), animated: true)
    }
   
    @objc func favoritesCurrencyPress() {
        
    }
    
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            conteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            conteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            conteinerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            conteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
             
            favoritesCurrencyButton.topAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: 20),
            favoritesCurrencyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            favoritesCurrencyButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            favoritesCurrencyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            currencyConverterButton.topAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: 20),
            currencyConverterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            currencyConverterButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            currencyConverterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
        
    }
}

extension StartLoadingScreenViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySelectionScreenTableViewCell.identifier, for: indexPath) as? CurrencySelectionScreenTableViewCell else { return UITableViewCell() }
        let currency = currencies?[indexPath.row]
        
        let model = Currensy(numCode: currency?.numCode ?? "000", charCode: currency?.charCode ?? "", nominal: currency?.nominal ?? 1, name: currency?.name ?? "Российский рубль", value: currency?.value ?? 1)
        cell.configureLoadingScreen(with: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
