//
//  Coredata.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import CoreData

class Coredata {
    
    func addRecentSearch(searchName: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: RECENT_SEARCH, in: CONTEXT!)
        let newSearch = NSManagedObject(entity: entity!, insertInto: CONTEXT)
        newSearch.setValue(searchName, forKey: SEARCH_TITLE)
        newSearch.setValue(Date(), forKey: CREATED_DATE)
        
        do {
          
            try CONTEXT!.save()
        }
        catch {
        
            print("Failed saving")
        }
    }
    
    func getRecentSearch() -> [RecentSearch] { // To get data from entity
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: RECENT_SEARCH)
        let aSortDesc = NSSortDescriptor.init(key: CREATED_DATE, ascending: false)
        fetchRequest.sortDescriptors = [aSortDesc]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
        
            let result = try CONTEXT!.fetch(fetchRequest)
            var aRecentSearchArray = [RecentSearch]()
            for data in result as! [NSManagedObject] {
                
                let aRecentSearch = RecentSearch(message:data.value(forKey: SEARCH_TITLE) as? String)
                aRecentSearchArray.append(aRecentSearch)// Store he data in model class fo easy use of it.
            }
            return aRecentSearchArray
        }
        catch {
            
            print("Failed")
            return [RecentSearch]()
        }
    }
    
    func deleteRecentSearch(searchName: String) {// To delete the paticular value from entity

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: RECENT_SEARCH)
        let predicate = NSPredicate(format: "searchTitle = %@", searchName)
        fetchRequest.predicate =  predicate

        do
        {
            let fetchedResults =  try CONTEXT!.fetch(fetchRequest)

            for entity in fetchedResults {

                CONTEXT?.delete(entity)
            }
            
            do {
                
                try CONTEXT!.save()
            }
            catch {
                
                print("Failed saving")
            }
        }
        catch _ {
            print("Could not delete")

        }
    }
}

