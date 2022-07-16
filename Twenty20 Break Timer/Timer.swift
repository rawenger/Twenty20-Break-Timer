//
//  Timer.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/12/22.
//

import Foundation
import AppKit

@inline(__always) func floor(_ num: Double) -> Double { return Double(Int(num)) }


public final class BreakTimerController: ObservableObject {
    static let shared = BreakTimerController(breakDuration: 20.0, breakInterval: 20.0)
    
    public var isBreakHappening = false

    private var startTime: DateComponents?
    
    private var timer: Timer?
    
    private var timeRemaining: TimeInterval?
    
    // need to floor the stored properties b/c SwiftUI slider won't round them off for us
    private var breakIntervalSeconds: TimeInterval {
        get { return floor(breakInterval) * 60.0 }
        set { breakInterval = newValue / 60.0 }
    }
    
    private var breakDurationSeconds: TimeInterval {
        get { return floor(breakDuration) }
        set { breakDuration = newValue }
    }

    @Published public var breakDuration: TimeInterval
    
    @Published public var breakInterval: TimeInterval
    
    public init(breakDuration: TimeInterval, breakInterval: TimeInterval) {
        print("creating new BreakTimerController object")
        self.breakDuration = breakDuration
        self.breakInterval = breakInterval
    }
    
    public func startTimer(timeInSeconds: TimeInterval? = nil) {
        let time = timeInSeconds ?? breakIntervalSeconds
        timer = Timer.scheduledTimer(withTimeInterval: time,
                                     repeats: false,
                                     block: showBreakTimeAlert)
        timer!.tolerance = 15
    }
    
    /// Pauses the timer
    public func pauseTimer() {
        // need to get current time & fire time, then save difference internally
        // so it can be used when resuming the timer (which really just starts a new timer
        // set to fire after the remaining time interval)
//        guard let tmr = timer else { print("Cannot pause a timer that wasn't running"); return }
        if (isBreakHappening) { return }
        
        timeRemaining = timer!.fireDate.timeIntervalSinceNow
        timer!.invalidate()
         
    }
    
    /// Resumes the timer after a pause
    public func resumeTimer() {
         startTimer(timeInSeconds: timeRemaining!)
    }
    
    /// Stops the timer
    public func stopTimer() {
        timer!.invalidate()
    }
    
//    /// Restarts the timer
//    public func restartTimer() {
//        timer!.invalidate()
//        startTimer(
//    }
    
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
    
    /**
     Shows a popup alert to the user informing them that it's time for a break
     I'm still not sure exactly how I want this to behave: should the 20 second timer
     begin immediately without requiring user interaction, or should it wait until the "OK" button has been pressed?
     Luckily, the popup is configured to bring itself into focus, so the user just needs to hit the 'Enter' key
     when it the alert appears to automatically select "OK"
     */
    private func showBreakTimeAlert(_ caller: Timer) {
        
        // Save the previous frontmost application so we can restore it after
        // the user dismisses our popup alerts
        let oldKeyApp = NSWorkspace.shared.frontmostApplication
        
        let alert = NSAlert()
        alert.messageText = "(fake) Break Time!"
        alert.informativeText = "Take 20 seconds to focus your eyes on an object at least 20 feet away"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Skip this break") // or should it just be "Skip"?
        
        alert.window.level = .floating
        NSApp.activate(ignoringOtherApps: true)
        alert.window.makeKey()
        
        let ok = alert.runModal() == .alertFirstButtonReturn
        print("Chose option \(ok ? "OK" : "Skip")")
        
        if (ok) {
            isBreakHappening = true
            timer = Timer.scheduledTimer(withTimeInterval: breakDurationSeconds,
                                         repeats: false,
                                         block: showEndBreakAlert)
            timer!.tolerance = 0
        }
        
        // Restore old frontmost app
        oldKeyApp?.activate()
    }
    
    /// TODO: Store and return previously active application to the foreground after alert is dismissed
    /// (store needs to be done in `showBreakTimeAlert()`)
    private func showEndBreakAlert(_ caller: Timer) {
        
        let oldKeyApp = NSWorkspace.shared.frontmostApplication
        
        let alert = NSAlert()
        alert.messageText = "(fake) Break Over!"
        alert.informativeText = "Pressing 'OK' will start another timer"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Stop")
        
        alert.window.level = .floating
        NSApp.activate(ignoringOtherApps: true)
        alert.window.makeKey()
        
        // TODO: play alert sound
        NSSound(named: "Glass")?.play()
        
        
        let ok = alert.runModal() == .alertFirstButtonReturn
        print("Chose option \(ok ? "OK" : "Stop").")
        
        if (ok) {
            isBreakHappening = false
            startTimer()
        }
        
        oldKeyApp?.activate()

    }
    
//    public func loadValue() {
//        DispatchQueue.main.async {
//
//        }
//    }
}
