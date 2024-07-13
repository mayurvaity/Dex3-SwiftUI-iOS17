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
    
    //to keep state of pokemon image type (shiny/ sprite)
    @State var showShiny = false
    
    var body: some View {
        ScrollView {
            //for pokemon image and bg
            ZStack {
                //background image
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                //pokemon image
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                    
                } placeholder: {
                    ProgressView()
                }
            }
            
            //for pokemon types
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized)) //colors with same name as types (capitalized) are stored in the assets folder
                        .cornerRadius(50)
                }
                
                //to align all the types to the left
                Spacer()
            }
            .padding()
        }
        .navigationTitle(pokemon.name!.capitalized) //to add pokemon name in navigation bar
        .toolbar {
            //to add button in navbar above in top-right corner 
            ToolbarItem(placement: .topBarTrailing) {
                //content:
                //button to swtich pokemon image
                Button {
                    showShiny.toggle()
                } label: {
                    //setting button icon as per showshiny value
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
     PokemonDetailView()
        .environmentObject(SamplePokemon.samplePokemon) //to pass samplePokemon obj to the detail view
}
