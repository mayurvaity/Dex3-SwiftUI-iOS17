//
//  Dex3Widget.swift
//  Dex3Widget
//
//  Created by Mayur Vaity on 14/07/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    //fetching and storing random pokemon 
    var randomPokemon: Pokemon {
        //creating viewContext of preview data from coredata
        let context = PersistenceController.shared.container.viewContext
        
        //creating fetchrequest to get data from abv created viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        //array to store all the pokemon data from coredata db
        var results: [Pokemon] = []
        //getting all the pokemon data from coredata db
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch, \(error)")
        }
        //checking if we got any data from fetch reqst
        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        //if couldn't get pokemon from coredata db, return sample one
        return SamplePokemon.samplePokemon
    }
    
    //fn to show in case data is NA
    func placeholder(in context: Context) -> SimpleEntry {
        //as it is just a placeholder, we are using samplePokemon
        SimpleEntry(date: Date(),
                    configuration: ConfigurationAppIntent(),
                    pokemon: SamplePokemon.samplePokemon)
    }
    
    //fn for a snapshot widget, never changing widget data
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        //here we need to use real pokemon data
        SimpleEntry(date: Date(),
                    configuration: configuration,
                    pokemon: randomPokemon)
    }
    
    //fn for setting timeline for changing widget, it'll change as per time specified below
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

//swift obj type created to form obj which can be used to store any data that we want to display
struct SimpleEntry: TimelineEntry {
    //below date is compulsary as we are conforming to "TimelineEntry" protocol
    let date: Date
    let configuration: ConfigurationAppIntent
    let pokemon: Pokemon
}

//vw of how data is shown in the widget
struct Dex3WidgetEntryView : View {
    //to access widgetFamily property (which tells size of the widget) and keep the value in this var
    @Environment(\.widgetFamily) var widgetSize
    
    //this will get SimpleEntry obj, and can be used below to access pokemon data
    var entry: Provider.Entry

    var body: some View {
        VStack {
            switch widgetSize {
            case .systemSmall:
                WidgetPokemonView(widgetSize: .small)
                    .environmentObject(entry.pokemon)
            
            case .systemMedium:
                WidgetPokemonView(widgetSize: .medium)
                    .environmentObject(entry.pokemon)
            
            case .systemLarge:
                WidgetPokemonView(widgetSize: .large)
                    .environmentObject(entry.pokemon)
            
            default:
                WidgetPokemonView(widgetSize: .large)
                    .environmentObject(entry.pokemon)
            }
        }
    }
}

//this is main driver of the widget
struct Dex3Widget: Widget {
    let kind: String = "Dex3Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Dex3WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//as - to specify widgetsize, available values are: [systemMedium, systemLarge, systemSmall]
#Preview(as: .systemSmall) {
    Dex3Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemMedium) {
    Dex3Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}

#Preview(as: .systemLarge) {
    Dex3Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}
