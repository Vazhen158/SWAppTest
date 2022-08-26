//
//  ModelCoreData.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import CoreData

//class FavoritesCurrency: NSManagedObject {
//    @NSManaged var name: String
//    @NSManaged var charCode: String
//    @NSManaged var valute: Double
//    @NSManaged var selected: Bool
//}
class TerminsCDManager44 {
    
    var allTermins: [Item] = []
    
    let persistantContainer: NSPersistentContainer
    
    init() {
        persistantContainer = NSPersistentContainer(name: "DataModel")
        persistantContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("error while init termins VM CD \(error.localizedDescription)")
            }
        }
        
        loadTermins()

        saveTerminsData()
    }
    
    
    
    func saveTerminsData() {
        
        do {
            try persistantContainer.viewContext.save()
            loadTermins()
        } catch let error {
            fatalError("CDManagerTerminsVM saving error \(error.localizedDescription)")
        }
        print("termins saved sucsessfully")
    }
    
    
    
     func loadTermins() {
        let request = NSFetchRequest<Item>(entityName: "DataModel")
        
        do {
            allTermins = try persistantContainer.viewContext.fetch(request)
        } catch let error {
            fatalError("CDManagerTerminsVM fetch failed with error \(error.localizedDescription)")
        }
    }
    
     func addTermin(cathegory: String) {
        
        let newTermin = Item(context: persistantContainer.viewContext)
        
        newTermin.name = cathegory
        
        saveTerminsData()
        print("termin added sucsessfully")
    }
    
     func deleteAllTermins() {
        let request = NSFetchRequest<Item>(entityName: "DataModel")
        
        do {
            let deleteTermins = try persistantContainer.viewContext.fetch(request)
            
            for termin in deleteTermins {
                persistantContainer.viewContext.delete(termin)
            }
            
            saveTerminsData()
            
        } catch let error {
            fatalError("CDManagerTerminsVM deleting error \(error.localizedDescription)")
        }
        print("termins deleted sucsessfully")
    }
}
