//
//  Dex3_SwiftUI_iOS17App.swift
//  Dex3-SwiftUI-iOS17
//
//  Created by Mayur Vaity on 10/07/24.
//

import SwiftUI

@main
struct Dex3_SwiftUI_iOS17App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
