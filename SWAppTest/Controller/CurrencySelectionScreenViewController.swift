//
//  CurrencySelectionScreenViewController.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 25.08.2022.
//

import Foundation
import UIKit

protocol FromSelectionDelegate {
    func didSelectFrom(currencies: Currensy?)
}

protocol ToSelectionDelegate {
    func didSelectTo(currencies: Currensy?)
}

class CurrencySelectionScreenViewController: UIViewController {
    
    private var currencies: [Currensy]?
    
    private let url = "https://www.cbr.ru/scripts/XML_daily.asp"
    var fromCurrency = Currensy(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    var toCurrency  = Currensy(numCode: "000", charCode: "RUR", nominal: 1, name: "Российский рубль", value: 1)
    var fromSelectionDelegate: FromSelectionDelegate!
    var toSelectionDelegate: ToSelectionDelegate!
    
    
    public let fromCurrenciesTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencySelectionScreenTableViewCell.self, forCellReuseIdentifier: CurrencySelectionScreenTableViewCell.identifier)
        return table
    }()
    
    public let toCurrenciesTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencySelectionScreenTableViewCell.self, forCellReuseIdentifier: CurrencySelectionScreenTableViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select currency"
        view.addSubview(fromCurrenciesTableView)
        // view.addSubview(toCurrenciesTableView)
        setConstraint()
        fetchData()
        productTableConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fromCurrenciesTableView.frame = view.bounds
        
    }
    
    private func productTableConfigure() {
        fromCurrenciesTableView.delegate = self
        fromCurrenciesTableView.dataSource = self
        //        toCurrenciesTableView.delegate = self
        //        toCurrenciesTableView.dataSource = self
    }
    
    private func fetchData() {
        let parser = CurrensyParser()
        parser.parseСurrencies(url: url) { (currensies) in
            self.currencies = currensies
            self.currencies?.append(self.fromCurrency)
            DispatchQueue.main.async {
                self.fromCurrenciesTableView.reloadData()
                // self.toCurrenciesTableView.reloadData()
            }
        }
    }
    
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            fromCurrenciesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fromCurrenciesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fromCurrenciesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            fromCurrenciesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            //            toCurrenciesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            //            toCurrenciesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            //            toCurrenciesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
        ])
    }
    
}

extension CurrencySelectionScreenViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySelectionScreenTableViewCell.identifier, for: indexPath) as? CurrencySelectionScreenTableViewCell else { return UITableViewCell() }
        let currency = currencies?[indexPath.row]
        
        let model = Currensy(numCode: currency?.numCode ?? "000", charCode: currency?.charCode ?? "", nominal: currency?.nominal ?? 1, name: currency?.name ?? "Российский рубль", value: currency?.value ?? 1)
        cell.configure(with: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            
           } else {
               tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
           }
        
        if tableView == fromCurrenciesTableView {
            fromSelectionDelegate.didSelectFrom(currencies: currencies?[indexPath.row])
            
        }
        if tableView == fromCurrenciesTableView {
            toSelectionDelegate.didSelectTo(currencies:  currencies?[indexPath.row])
            
        }
        
    }
    
}
