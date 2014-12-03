//
//  AppDelegate.swift
//  MDPSplitViewDemo
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var windowController = { MainWindowController(windowNibName: "MainWindow") }()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		windowController.showWindow(nil)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

