//
//  StatsView.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 14/07/24.
//

import SwiftUI
import Charts

struct StatsView: View {
    //getting pokemon data from env obj
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        //to create a chart
        Chart(pokemon.stats) { stat in
            //to add bars in bar chart
            BarMark(
                x: .value("value", stat.value),
                y: .value("stat", stat.label)
            )
            .annotation(position: .trailing) {
                //annotaion - for label on bar values 
                //position - to put values behind the bars
                Text("\(stat.value)")
                    .padding(.top, -5) //to move these numbers up a little
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(height: 200)
        .padding([.leading, .bottom, .trailing])
        .foregroundStyle(Color(pokemon.types![0].capitalized)) //to set colors of bars
        .chartXScale(domain: 0...pokemon.highestStat.value+5)  //setting max value on x axis (by setting highest stat value + 5) (+5 to keep bar annotation lable)
    }
}

#Preview {
    StatsView()
        .environmentObject(SamplePokemon.samplePokemon) //passing env obj here
}
