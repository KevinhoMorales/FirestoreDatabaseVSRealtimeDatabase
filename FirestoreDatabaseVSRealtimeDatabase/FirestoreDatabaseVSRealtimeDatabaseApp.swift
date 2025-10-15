//
//  FirestoreDatabaseVSRealtimeDatabaseApp.swift
//  FirestoreDatabaseVSRealtimeDatabase
//
//  Created by Kevinho Morales on 15/10/25.
//

import SwiftUI
import FirebaseCore

@main
struct FirestoreDatabaseVSRealtimeDatabaseApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
