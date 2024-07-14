//
//  PokemonViewModel.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 13/07/24.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    //status types
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    //var to keep current status
    @Published private(set) var status = Status.notStarted
    
    //to keep FetchController obj
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
        
        //putting this fn call into a task, as we cannot directly run async funcs
        Task {
            //calling fn as soon as obj of this ViewModel is created
            await getPokemon()
        }
    }
    
    //fn to call fns that get data from API and then storing it into coredata 
    private func getPokemon() async {
        status = .fetching
        
        do {
            //calling fn and getting all pokemon data (from API)
            guard var pokedex = try await controller.fetchAllPokemon() else {
                //if no data has been returned from this fn, that means we already got all the data in coredata db
                print("Pokemon have already been got. we good.")
                //setting status as no more processing is required
                status = .success
                //ending this fn here
                return
            }
            
            //sorting
            pokedex.sort { $0.id < $1.id }
            
            //saving all pokemon to CoreData db
            for pokemon in pokedex {
                //creating an obj of "Pokemon", a coredata table row type
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                
                //assignin values to attributes of "Pokemon" obj
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeTypes()  //to swap 1st type (if normal) with 2nd type 
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false 
                
                //saving abv pokemon into coredata db
                try PersistenceController.shared.container.viewContext.save()
            }
            
            //setting status as abv op was successful
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
