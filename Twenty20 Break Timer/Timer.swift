//
//  Timer.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/12/22.
//

import Foundation
import AppKit


public final class BreakTimerController: ObservableObject {
    static let shared = BreakTimerController(breakDuration: 20.0, breakInterval: 20.0 * 60.0)
    
    public var isBreakHappening = false

    private var startTime: DateComponents?
    
    private var timer: Timer?
    
    private var timeRemaining: TimeInterval?
    
    private var breakIntervalSeconds: TimeInterval
    private var breakDurationSeconds: TimeInterval

    public var breakDuration: Int {
        get { return Int(breakDurationSeconds) }
        set { breakDurationSeconds = Double(newValue) }
    }
    
    public var breakInterval: Int {
        get { return Int(breakIntervalSeconds) / 60 }
        set { breakIntervalSeconds = Double(newValue * 60) }
    }
    
    public init(breakDuration: TimeInterval, breakInterval: TimeInterval) {
        print("creating new BreakTimerController object")
        breakDurationSeconds = breakDuration
        breakIntervalSeconds = breakInterval
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
        
        let alert = NSAlert()
        alert.messageText = "Break Time!"
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
            timer!.tolerance = 15
        }
    }
    
    /// TODO: Store and return previously active application to the foreground after alert is dismissed
    /// (store needs to be done in `showBreakTimeAlert()`)
    private func showEndBreakAlert(_ caller: Timer) {
        
        let alert = NSAlert()
        alert.messageText = "Break Over!"
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
    }
    
//    public func loadValue() {
//        DispatchQueue.main.async {
//
//        }
//    }
}
