//
//  ContentView.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/11/22.
//

import SwiftUI

func launchSettings() {
    // the only way I could find to do this that didn't involve creating a whole new class
    // uses a private API :(
    // ... and a selector that was renamed in macOS 13:
    // https://stackoverflow.com/q/65355696
    if #available(OSX 13, *) {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    } else {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
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
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(timerController.getFireTime())
                .font(.title)
//                .fontWeight(.bold)
                .foregroundColor(Color.white)
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

struct SettingsView: View {
    @State private var launchAtLogin = PersistenceManager.instance.launchAtLogin ?? false
    
    /// time between breaks in *minutes*
    @State private var breakInterval = PersistenceManager.instance.breakInterval ?? 20
        
    /// duration of each break in *seconds*
    @State private var breakDuration = PersistenceManager.instance.breakDuration ?? 20
    
    @ObservedObject private var timerController = BreakTimerController.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 15)
            HStack {
                // TODO: make it so the text box corrects out of bounds values
                // (otherwise they will be silently applied to the `breakInterval`
                // variable)
                Text("Minutes between breaks:").padding(.leading)
                TextField("Number", value: Binding(
                    /// TODO: consider changing `BreakTimerController.breakInterval` & `Duration` to `Double`s
                    get: {
                        Float(timerController.breakInterval)
                    },
                    set: { newValue in
                        if newValue < 1 {
                            timerController.breakInterval = 1
                        } else if newValue > 60 {
                            timerController.breakInterval = 60
                        } else {
                            timerController.breakInterval = Int(newValue)
                        }
                        print("breakInterval: \(timerController.breakInterval) minutes")
                    }
                ), formatter: NumberFormatter())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 50)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // TODO: figure out how to make this smaller (vertically)
            Spacer()
            
            Slider(value: Binding(
                get: {
                    Float(breakInterval)
                },
                set: { newValue in
                    if newValue < 1 {
                        breakInterval = 1
                    } else if newValue > 60 {
                        breakInterval = 60
                    } else {
                        breakInterval = Int(newValue)
                    }
                    
                }
            ), in: 1...60).padding(.horizontal).padding(.top, -20)
            
            //                VStack(alignment: .leading) {
            //                    Slider(
            //                        value: $breakInterval,
            //                        in: 1...60,
            //                        step: 1,
            //                        onEditingChanged: <#T##(Bool) -> Void#>
            
            //                        isOn: Binding(
            //                        get: { launchAtLogin },
            //
            //                        set: { newValue in
            //                            launchAtLogin = newValue
            //                            print("Launch at login turned \(newValue ? "on" : "off")!")
            ////                            LaunchAtLogin.isEnabled = newValue
            //                        }
            //                    )) {
            //                        Text("Launch at login")
            //                    }
            
        }.frame(width: 400, height: 200)
    }
}

struct Settings_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

