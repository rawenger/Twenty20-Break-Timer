//
//  Twenty20_Break_TimerApp.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/11/22.
//

import SwiftUI

@main
struct Twenty20_Break_TimerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
