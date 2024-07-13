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
    
    func organizeTypes() {
        //checking if a pokemon has multiple types and 1st one is "normal"
        if self.types!.count > 1 && self.types![0] == "normal" {
            //swapping 1st and 2nd values in types array
//            let tempType = self.types![0]
//            self.types![0] = self.types![1]
//            self.types![1] = tempType
            self.types!.swapAt(0, 1) //apple fn for this swapping process 
        }
    }
}

//model of stats
struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
