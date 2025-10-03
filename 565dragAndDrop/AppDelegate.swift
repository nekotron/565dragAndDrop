//
//  AppDelegate.swift
//  565dragAndDrop
//
//  Created by ジャスティン on 09/27/25.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    

    @IBAction func fileOpenClicked(_ sender: Any) {
        // Create instance of notification center and send it off to where it will be picked up in the view controller.
        let notify = NotificationCenter.default
        notify.post(name: Notification.Name("OpenClicked"), object: nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

