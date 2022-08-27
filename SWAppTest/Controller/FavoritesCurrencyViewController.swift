//
//  FavoritesCurrencyViewController.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import Foundation
import UIKit
import CoreData

class FavoritesCurrencyViewController: UIViewController {
    
    private var currencyItem = [Item]()
    private var currencyCDManager = CurrencyCDManager44()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public let favoritesTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencySelectionScreenTableViewCell.self, forCellReuseIdentifier: CurrencySelectionScreenTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favoritesTableView)
        title = "Favorites currency"
        view.backgroundColor = .white
        setConstraint()
        currencyTableConfigure()
        loadItems()
    }
    
    private func currencyTableConfigure() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
        ])
    }
    
}

extension FavoritesCurrencyViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySelectionScreenTableViewCell.identifier, for: indexPath) as? CurrencySelectionScreenTableViewCell else { return UITableViewCell() }
        let item = currencyItem[indexPath.row]
        let model = Currensy(numCode: nil, charCode: item.charCode ?? "", nominal: nil, name: item.name ?? "", value: item.value )
        cell.configureLoadingScreen(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let currenciesFavorites = currencyItem[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // добавляет возможность удаления ячейки
         
            context.delete(currencyItem[indexPath.item]) // удаляет данные из permanent store, всегда должен быть выше remove(at:)
            currencyItem.remove(at: indexPath.row) // удаляет текущий элемент
            currencyCDManager.saveCurrencyData()
            favoritesTableView.reloadData()
        }
    }
    
    
}

extension FavoritesCurrencyViewController {
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ addtionalPredicate])
        }
        
        do {
            currencyItem = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        favoritesTableView.reloadData()
        
    }
}
