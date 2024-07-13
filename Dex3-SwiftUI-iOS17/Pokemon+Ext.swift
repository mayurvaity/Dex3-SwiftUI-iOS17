//
//  Pokemon+Ext.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 13/07/24.
//

import Foundation

//to create calculated properties in data model, we r extending it
extension Pokemon {
    //for bg image in detailView
    var background: String {
        //getting 1st element from types array to determine background image name 
        switch self.types![0] {
        case "normal", "grass", "electric", "poison", "fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "invalidType"
        }
    }
    
    //to create an array of all stats
    var stats: [Stat] {
        [
            Stat(id: 1, label: "HP", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defense", value: self.defense),
            Stat(id: 4, label: "Special Attack", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed)
        ]
    }
    
    //stat with highest value
    var highestStat: Stat {
        stats.max { $0.value < $1.value }!
    }
}

//model of stats
struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
