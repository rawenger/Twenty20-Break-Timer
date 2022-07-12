//
//  AppDelegate.swift
//  Twenty20 Break Timer
//
//  Created by Ryan Wenger on 7/11/22.
//

import Cocoa
import SwiftUI
import AppKit

//@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // create SwiftUI view
        let contentView = ContentView()
        
        // create popover window
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // create status bar item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "statusbar_icon")
            button.action = #selector(togglePopover(_:))
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        popover.contentViewController?.view.window?.becomeKey()
        
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
}
