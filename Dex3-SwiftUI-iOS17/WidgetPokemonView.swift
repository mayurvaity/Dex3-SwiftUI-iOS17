//
//  WidgetPokemonView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 14/07/24.
//

import SwiftUI

//enum for sizes for widget
enum WidgetSize {
    case small, medium, large
}

struct WidgetPokemonView: View {
    //var to store pokemon obj, to use below
    @EnvironmentObject var pokemon: Pokemon
    //var to store widgetsize
    let widgetSize: WidgetSize
    
    var body: some View {
        ZStack {
            //to set bg color for widgets (of all sizes)
            Color(pokemon.types![0].capitalized)
            
            //creating vws as per the widgetsize 
            switch widgetSize {
            case .small:
                FetchedImageView(url: pokemon.sprite)
                
            case .medium:
                HStack {
                    //for pokemon image
                    FetchedImageView(url: pokemon.sprite)
                    
                    //for name and types data of pokemon
                    VStack(alignment: .leading) {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        
                        //joined -  to combine elements of arrays with a separator and form a string
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing, 30)
                }
                
            case .large:
                FetchedImageView(url: pokemon.sprite)
                
                VStack {
                    HStack {
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    WidgetPokemonView(widgetSize: .large)
        .environmentObject(SamplePokemon.samplePokemon)
}
