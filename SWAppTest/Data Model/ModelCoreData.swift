//
//  ModelCoreData.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import CoreData

class CurrencyCDManager44 {
    
    var allCurrency: [Item] = []
    let persistantContainer: NSPersistentContainer

    init() {
        persistantContainer = NSPersistentContainer(name: "DataModel")
        persistantContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("error while init termins VM CD \(error.localizedDescription)")
            }
        }

        loadCurrency()

        saveCurrencyData()
    }

    func saveCurrencyData() {
        
        do {
            try persistantContainer.viewContext.save()
            loadCurrency()
        } catch let error {
            fatalError("DataModel saving error \(error.localizedDescription)")
        }
        print("Currensy saved sucsessfully")
    }

    func loadCurrency() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        do {
            allCurrency = try persistantContainer.viewContext.fetch(request)
        } catch let error {
            fatalError("DataModel fetch failed with error \(error.localizedDescription)")
        }
    }
    
    func addTermin(name: String, charCode: String, value: Double) {
        
        let newCurrency = Item(context: persistantContainer.viewContext)
        newCurrency.name = name
        newCurrency.charCode = charCode
        newCurrency.value = value
        saveCurrencyData()

        print("Currency added sucsessfully")
        
    }
    
    func deleteAllCurrency() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        
        do {
            let deleteCurrency = try persistantContainer.viewContext.fetch(request)
            
            for currency in deleteCurrency {
                persistantContainer.viewContext.delete(currency)
                
            }
            saveCurrencyData()
          
            
        } catch let error {
            fatalError("DataModel deleting error \(error.localizedDescription)")
        }
        print("Currency deleted sucsessfully")
    }
}
