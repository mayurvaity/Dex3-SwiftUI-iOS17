//
//  ContentView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 10/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    var body: some View {
        NavigationStack {
            List(pokedex) { pokemon in
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
                }
            }
            .navigationTitle("Pokedex")
            //navigationDestination - to specify destination view (detail view) when clicked on any row from abv list 
            .navigationDestination(for: Pokemon.self,
                                   destination: { pokemon in
                //destination for when clicked on a item from the list
                AsyncImage(url: pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100) //putting frame here instead of inside (some size issue, need to check)
                
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
