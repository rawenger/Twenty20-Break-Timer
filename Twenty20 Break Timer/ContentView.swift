//
//  ContentView.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/11/22.
//

/* TODO:
 - fix visibility in light mode ✅
 - fix variability in 20-second break timer (maybe reduce tolerance to zero/show a live countdown on screen?)
 - get transient settings to work
 - make it so popover window updates to show the next break time
 - add visual functionality to pause/stop buttons
 - make it look good visually
 - change menubar icon to dark color when in dark mode ✅
 - refactor TimerController to use the `NSBackgroundActivityScheduler` API
    (https://developer.apple.com/library/archive/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/SchedulingBackgroundActivity.html)
 */

import SwiftUI

func launchSettings() {
    
    // The only way I could find to do this in SwiftUI that didn't involve creating
    // a whole new class uses a private API :(
    // ... and a selector that was renamed in macOS 13:
    // https://stackoverflow.com/q/65355696
    // Not sure why `Settings()` doesn't work, but oh well
    if #available(OSX 13, *) {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    } else {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
    
    NSApp.activate(ignoringOtherApps: true)
}

struct RunningTimerView: View {
    
    @ObservedObject private var timerController = BreakTimerController.shared
//    @EnvironmentObject private var progress = BreakTimerData.shared.getProgress()
    
    private let parent: ContentView
    
    public init(parent: ContentView) {
        // START THE TIMER
        self.parent = parent
        timerController.startTimer()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(timerController.isBreakHappening ? "Break Over At" : "Next Break At")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(timerController.getFireTime())
                .font(.title)
//                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(alignment: .center) {
                // TODO: add resume functionality (timerController.resumeTimer)
                Button(action: timerController.pauseTimer) {
                    Image(systemName: "pause.circle")
                }.padding(10)
                
                Button(action: timerController.stopTimer) {
                    Image(systemName: "stop.circle")
                }.padding(10)
                
                // might get rid of later
//                Button(action: {} ) {
//                    Image(systemName: "gobackward")
//                }.padding(5)

                Button(action: launchSettings) {
                    Image(systemName: "gearshape.fill")
                }.padding(10)
                
            }

        }
        
    }
    
}

struct IdleTimerView: View {
    
    private let parent: ContentView
    
    public init(parent: ContentView) {
        self.parent = parent
    }
    
    var body: some View {
        // TODO: consider making these buttons the same width--currently it looks kinda weird
        VStack(alignment: .leading) {
            Button(action: { parent.timerRunning = true; print("starting timer") }) {
                Label("Start timer", systemImage: "hourglass.bottomhalf.filled").symbolRenderingMode(.multicolor)
            }
            
            Button(action: launchSettings) {
                Label("Settings", systemImage: "gearshape.fill").symbolRenderingMode(.multicolor)
            }
        }
    }
}

// TODO: Make this look prettier (maybe make buttons equal length, or use two columns & more square shapes instead of one column)
struct ContentView: View {
    @State public var timerRunning = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if timerRunning {
                RunningTimerView(parent: self)
            } else {
                IdleTimerView(parent: self)
            }

            Button(role: .destructive, action: { NSApp.terminate(self); print("Bye-bye") }) {
                Label("Quit Twenty20", systemImage: "xmark.octagon.fill").symbolRenderingMode(.multicolor)
            }
        }.frame(width: 225, height: 300)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//struct RunningTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunningTimerView(ContentView())
//    }
//}
//
//struct IdleTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        IdleTimerView(parent: ContentView())
//    }
//}

//TODO: make this hook into PersistenceManager.swift so prefs will actually be preserved across launches
struct SettingsView: View {
    @State private var launchAtLogin = PersistenceManager.instance.launchAtLogin ?? false
    
    /// time between breaks in *minutes*
//    @State private var breakInterval = PersistenceManager.instance.breakInterval ?? 20
        
    /// duration of each break in *seconds*
//    @State private var breakDuration = PersistenceManager.instance.breakDuration ?? 20
    
    @ObservedObject private var timerController = BreakTimerController.shared
    
    var body: some View {
        
        // TODO: consider revisiting this to tweak the behavior when too large a value is entered
        // (cap at 60 rather than truncating to the maximum digits <= 60)
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 60
        formatter.allowsFloats = false

        return VStack(alignment: .leading) {
            
            Spacer().frame(height: 15)
            HStack {
                Text("Minutes between breaks:").padding(.leading)
                TextField("Number", value: $timerController.breakInterval, formatter: formatter)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // TODO: figure out how to make this smaller (vertically)
            Spacer()
            
            Slider(
                value: $timerController.breakInterval,
                in: 1...60,
//                step: 5,
                label: {},
                minimumValueLabel: { Text("1") },
                maximumValueLabel: { Text("60") },
                onEditingChanged: { edited in print("breakInterval: \(timerController.breakInterval)") }
            ).padding(.horizontal).padding(.top, -20)
            
        }.frame(width: 400, height: 200)
    }
}

struct Settings_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

