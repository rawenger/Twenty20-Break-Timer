//
//  ContentView.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var launchAtLogin = true
    
    /// time in MINUTES between breaks
    @State private var breakInterval = 20
    /// duration of each break in seconds
    @State private var breakDuration = 20
    
//    var body: some View {
//        Text("Hello, world!")
//            .padding()
//    }
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 15)
            HStack {
                // TODO: make it so the text box corrects out of bounds values (otherwise they will be silently applied to the `breakInterval` variable)
                Text("Minutes between breaks:").padding(.leading)
                                TextField("Number", value: Binding(
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
                                        print("breakInterval: \(breakInterval) minutes")
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
//    }

//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
