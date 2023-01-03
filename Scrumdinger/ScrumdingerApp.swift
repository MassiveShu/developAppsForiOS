//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Max Shu on 03.01.2023.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: DailyScrum.sampleData)
            }
        }
    }
}
