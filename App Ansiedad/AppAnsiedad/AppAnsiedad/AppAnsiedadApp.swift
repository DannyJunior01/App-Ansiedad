//
//  AppAnsiedadApp.swift
//  AppAnsiedad
//

import SwiftUI
import Firebase

@main
struct AppAnsiedadApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            BienvenidaView()
        }
    }
}
