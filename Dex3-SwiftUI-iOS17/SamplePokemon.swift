//
//  SamplePokemon.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 13/07/24.
//

import Foundation
import CoreData

//to fetch a sample pokemon data from preview persistentcontroller (to be used everywhere in the previews) 
struct SamplePokemon {
    static let samplePokemon = {
        //creating viewContext of preview data from coredata
        let context = PersistenceController.preview.container.viewContext
        
        //creating fetchrequest to get data from abv created viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        //limiting fetch request to fetch only 1 pokemon
        fetchRequest.fetchLimit = 1
        
        //getting pokemon data using abv fetchreqst
        let results = try! context.fetch(fetchRequest)
        
        //return
        return results.first!
    }()
    
}
