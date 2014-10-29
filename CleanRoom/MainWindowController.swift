//
//  MainWindowController.swift
//  CleanRoom
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSplitViewDelegate {
	func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
		return subview == splitView.subviews[0] as NSObject
	}
}
