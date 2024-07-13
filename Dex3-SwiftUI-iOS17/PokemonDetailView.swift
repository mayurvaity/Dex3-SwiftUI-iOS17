//
//  PokemonDetailView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 13/07/24.
//

import SwiftUI
import CoreData

struct PokemonDetailView: View {
    //to get selected pokemon data stored in Environment
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
     PokemonDetailView()
        .environmentObject(SamplePokemon.samplePokemon) //to pass samplePokemon obj to the detail view 
}
