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
    
    private let fromCurrencySelectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "From: "
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let toCurrencySelectLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "To: "
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
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
    
    private var conteinerViewTwo:  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
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
        view.backgroundColor = .white
        view.addSubview(conteinerView)
        view.addSubview(conteinerViewTwo)
        view.addSubview(fromCurrencySelectLabel)
        view.addSubview(toCurrencySelectLabel)
        conteinerView.addSubview(fromCurrenciesTableView)
        conteinerViewTwo.addSubview(toCurrenciesTableView)
        setConstraint()
        fetchData()
        productTableConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //fromCurrenciesTableView.frame = view.bounds
        
    }
    
    private func productTableConfigure() {
        fromCurrenciesTableView.delegate = self
        fromCurrenciesTableView.dataSource = self
        toCurrenciesTableView.delegate = self
        toCurrenciesTableView.dataSource = self
    }
    
    private func fetchData() {
        let parser = CurrensyParser()
        parser.parseСurrencies(url: url) { (currensies) in
            self.currencies = currensies
            self.currencies?.append(self.fromCurrency)
            self.currencies?.append(self.toCurrency)
            DispatchQueue.main.async {
                self.fromCurrenciesTableView.reloadData()
                self.toCurrenciesTableView.reloadData()
            }
        }
    }
    
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            
            fromCurrencySelectLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 0),
            fromCurrencySelectLabel.widthAnchor.constraint(equalTo: conteinerView.widthAnchor, multiplier: 0.35),
            fromCurrencySelectLabel.bottomAnchor.constraint(equalTo: conteinerView.topAnchor, constant: -15),
            
            conteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            conteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            conteinerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            conteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            toCurrencySelectLabel.leadingAnchor.constraint(equalTo: conteinerViewTwo.leadingAnchor, constant: 0),
            toCurrencySelectLabel.widthAnchor.constraint(equalTo: conteinerViewTwo.widthAnchor, multiplier: 0.35),
            toCurrencySelectLabel.bottomAnchor.constraint(equalTo: conteinerViewTwo.topAnchor, constant: -15),
            
            conteinerViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            conteinerViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            conteinerViewTwo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            conteinerViewTwo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            fromCurrenciesTableView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 0),
            fromCurrenciesTableView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: 0),
            fromCurrenciesTableView.topAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.topAnchor, constant: 0),
            fromCurrenciesTableView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: 0),

            toCurrenciesTableView.leadingAnchor.constraint(equalTo: conteinerViewTwo.leadingAnchor, constant: 0),
            toCurrenciesTableView.trailingAnchor.constraint(equalTo: conteinerViewTwo.trailingAnchor, constant: 0),
            toCurrenciesTableView.bottomAnchor.constraint(equalTo: conteinerViewTwo.bottomAnchor, constant: 0),
            toCurrenciesTableView.topAnchor.constraint(equalTo: conteinerViewTwo.safeAreaLayoutGuide.topAnchor, constant: 0),
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
   
        var currentItem = currencies?[indexPath.row]
        currentItem?.selected = true
            tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        if tableView == fromCurrenciesTableView {
            fromSelectionDelegate.didSelectFrom(currencies: currencies?[indexPath.row])
            
        }
        if tableView == toCurrenciesTableView {
            toSelectionDelegate.didSelectTo(currencies:  currencies?[indexPath.row])
            
        }
        
    }
    
}
