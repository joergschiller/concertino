//
//  ViewController.swift
//  Concertino
//
//  Created by Joerg on 21.04.16.
//  Copyright © 2016 j. All rights reserved.
//

import Cocoa
import WebKit
import CoreGraphics
import Carbon

class ViewController: NSViewController {

    private static var webView: WKWebView!
    
    private static func sendKey(keyCode: Int) {
        let event = CGEventCreateKeyboardEvent(nil, CGKeyCode(keyCode), true)
        CGEventPostToPid(NSProcessInfo.processInfo().processIdentifier, event)
    }
    
    // Returns true if event was handled.
    private static func handleKeyEvent(event: NSEvent) -> BooleanType {
        let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
        let keyFlags = (event.data1 & 0x0000FFFF)
        let keyDown = (((keyFlags & 0xFF00) >> 8)) == 0xA // KeyUp is OxB
        let keyRepeat = (keyFlags & 0x1) == 1
        
        if (keyDown && !keyRepeat) {
            switch Int32(keyCode) {
            case NX_KEYTYPE_PLAY:
                sendKey(kVK_Space)
                return true
            case NX_KEYTYPE_NEXT, NX_KEYTYPE_FAST:
                sendKey(kVK_RightArrow)
                return true
            case NX_KEYTYPE_PREVIOUS, NX_KEYTYPE_REWIND:
                sendKey(kVK_LeftArrow)
                return true
            default:
                break
            }
        }
        
        return false
    }
    
    override func loadView() {
        super.loadView()
        
        ViewController.webView = WKWebView(frame: view.frame)
        ViewController.webView.configuration.preferences.setValue(true, forKey: "plugInsEnabled")
        
        ViewController.webView.autoresizingMask = NSAutoresizingMaskOptions([.ViewWidthSizable,.ViewHeightSizable])
        
        view.addSubview(ViewController.webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://app.napster.com")
        let request = NSURLRequest(URL: url!)
        
        ViewController.webView.loadRequest(request)
        
        let port = CGEventTapCreate(
            CGEventTapLocation.CGSessionEventTap,
            CGEventTapPlacement.HeadInsertEventTap,
            CGEventTapOptions.Default,
            CGEventMask(1 << NX_SYSDEFINED),
            { (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, _: UnsafeMutablePointer<Void>) -> Unmanaged<CGEvent>? in
                
                if ViewController.handleKeyEvent(NSEvent(CGEvent: event)!) {
                    return nil
                } else {
                    return Unmanaged<CGEvent>.passUnretained(event)
                }
            },
            nil)
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, port, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes)
    }
    
    override func keyDown(theEvent: NSEvent) {
        // Need to override and do nothing here to avoid system sound after keypress (which will be simulated after pressing media keys).
    }
    
}

