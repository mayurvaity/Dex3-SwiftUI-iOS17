//
//  FetchController.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 11/07/24.
//

import Foundation

struct FetchController {
    //enum for errors
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    //fn to fetch all pokemon data 
    func fetchAllPokemon() async throws -> [TempPokemon] {
        //var to store received and then decoded data
        var allPokemon: [TempPokemon] = []
        
        //MARK: - 1 building url
        //386 - fetching only 1st 386 pokemons, as they belong to gen 1 to 3
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        //appending query to url, to specify how many pokemon's data to fetch (in this case 386)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        //checking if final url is valid, else throwing an error
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        //MARK: - 2 getting data and response
        //get data, response
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //MARK: - 3 checking response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        //MARK: - 4 getting data
        //converting data into dict
        //[String: Any] - type of JSON data, key of dict element is string and value can be Any type
        //also checking if "results" key is available in the converted data
        //results data is of type - [[String: String]] 
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        //going through the list of all pokemons received in abv statement
        for pokemon in pokedex {
            //checking if there a url string
            if let url = pokemon["url"] {
                //fetching pokemon by calling below fn on avlbl url string
                //and appending pokemon obj to "allPokemon" array
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    //to get data of each Pokemon
    //will call this function for each pokemon
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        //accessing url and getting data and response
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //checking response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        //decoding data from JSON format to swift obj "TempPokemon"
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("Fetched \(tempPokemon.id) : \(tempPokemon.name)")
        
        return tempPokemon
    }
}
