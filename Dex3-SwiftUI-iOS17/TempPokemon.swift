//
//  TempPokemon.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 11/07/24.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    let sprite: URL
    let shiny: URL
    
    //enum to navigate us through the structure of JSON API
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictinaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    //will decode data and assign values to vars in the init
    init(from decoder: Decoder) throws {
        //container - will contain overall json data for single pokemon
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        //MARK: - 1
        //can get values of vars which are at 0th level in the container
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        //MARK: - 2
        //to get types data
        //decodedTypes - to store types data
        var decodedTypes: [String] = []
        //creating inner container var (named "types" in JSON)
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        //looping through all the values in the array of "types" in JSON
        while !typesContainer.isAtEnd {
            //creating container for dict inside the array
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            //creating container for "type" inside the dict
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self,
                                                                         forKey: .type)
            
            //using this container for "type" getting name attribute
            let type = try typeContainer.decode(String.self, forKey: .name)
            //appending this value to the array of types
            decodedTypes.append(type)
        }
        //passing array of types to final var
        types = decodedTypes
        
        //MARK: - 3
        //creating container of "stats"
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        //looping through array found in "stats" container
        while !statsContainer.isAtEnd {
            //creating container of elements in the array
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictinaryKeys.self)
            //creating container of "stat" which is found within above
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictinaryKeys.StatKeys.self,
                                                                             forKey: .stat)
            
            //"stat" data can be 1 of followin 6 types (based on "name" attribute), so below switch statemnt to address each of the cases 
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("It will never get here so...")
            }
        }
        
        //MARK: - 4
        //creating "sprites" container
        let spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        
        //getting values of 2 attributes within "sprites" container
        sprite = try spritesContainer.decode(URL.self, forKey: .sprite)
        shiny = try spritesContainer.decode(URL.self, forKey: .shiny)
    }
}


