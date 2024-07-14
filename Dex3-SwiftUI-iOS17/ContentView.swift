//
//  ContentView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 10/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //fetch request (with sort) for all pokemon data from coredata
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    //creating fetch request, sorting & filtering data and keeping it in "favorites" var, for use when favorites filter is applied
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>
    
    //var to keep value of if applied favorites filter
    @State private var filterByFavorites = false
    
    //creating pokemon viemodel using new fetchController obj
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    var body: some View {
        //determining what to show based on status of viewModel (getting data from API) progress 
        switch pokemonVM.status {
        //when success - to show list of pokemons
        case .success:
            NavigationStack {
                //depending on favorites filter (if selected or not) switching btween datasets obtained from coredata db
                List(filterByFavorites ? favorites : pokedex) { pokemon in
                    //for pokedex row
                    //value - will be used later in navigationDestination
                    NavigationLink(value: pokemon) {
                        //pokemon image
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100) //putting frame here instead of inside (some size issue, need to check)
                        
                        Text(pokemon.name!.capitalized)
                        
                        if pokemon.favorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                //navigationDestination - to specify destination view (detail view) when clicked on any row from abv list
                .navigationDestination(for: Pokemon.self,
                                       destination: { pokemon in
                    //destination for when clicked on a item from the list
                    PokemonDetailView()
                        .environmentObject(pokemon) //passing selected pokemon data as env obj
                })
                .toolbar {
                    //button to filter favorites at top right corner
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //changing filter property when button pressed
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Filter By Favorites",
                                  systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundStyle(.yellow)
                        
                    }
                }
            }
        //default - for case when everything except success
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
