//
//  PersistenceManager.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/12/22.
//

import Foundation

class PersistenceManager {
    static let instance = PersistenceManager()
    
    /// whether to launch Twenty20 Break Timer on user account login
    public var launchAtLogin: Bool?
    /// time between breaks in *minutes*
    public var breakInterval: Int?
    /// duration of each break in *seconds*
    public var breakDuration: Int?
    
    public func load() {
        launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        breakInterval = UserDefaults.standard.integer(forKey: "breakInterval")
        breakDuration = UserDefaults.standard.integer(forKey: "breakDuration")
    }
    
    public func save() {
        UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
        UserDefaults.standard.set(breakInterval, forKey: "breakInterval")
        UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
    }
}
