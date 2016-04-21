//
//  AppDelegate.swift
//  Concertino
//
//  Created by Joerg on 21.04.16.
//  Copyright © 2016 j. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

}

