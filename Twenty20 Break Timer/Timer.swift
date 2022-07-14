//
//  Timer.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/12/22.
//

import Foundation
import AppKit

func startBreak() {
    let alert = NSAlert()
    alert.messageText = "Break Time!"
    alert.informativeText = "Take 20 seconds to focus your eyes on an object at least 20 feet away"
    alert.alertStyle = .informational
    alert.addButton(withTitle: "Dismiss")
    alert.addButton(withTitle: "Skip this break")
    print("Chose option \(alert.runModal() == .alertFirstButtonReturn ? 1 : 2)")
}


public final class BreakTimerController: ObservableObject {
    static let shared = BreakTimerController()
    
    public var isBreakHappening = false

    private var startTime: DateComponents?
    
    private var timer: Timer?
    
    public init() {//breakDuration: Int, breakInterval: Int) {
        print("creating new BreakTimerData object")
    }
    
    public func startTimer(timeInSeconds: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInSeconds, repeats: false, block: { tm in
            print("timer fired!")
//            self.isBreakHappening = !self.isBreakHappening
        })
        timer!.tolerance = 15
    }
    
    /// Pauses the timer
    public func pauseTimer() {
        // need to get current time & fire time, then save difference internally
        // so it can be used when resuming the timer (which really just starts a new timer
        // set to fire after the remaining time interval)
        
        /*
         now = Date()
         timer.invalide()
         self.timeRemaining = timer.fireTime - now
         */
    }
    
    /// Resumes the timer after a pause
    public func resumeTimer() {
         // self.startTimer(timeInSeconds: self.timeRemaining)
    }
    
    public func getFireTime() -> String {
       
        if let fireTime = timer?.fireDate {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
            return formatter.string(from: fireTime)
        } else {
            return "∞"
        }
        
    }
    
//    public func loadValue() {
//        DispatchQueue.main.async {
//
//        }
//    }
}
