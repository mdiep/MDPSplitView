//
//  MainWindowController.swift
//  CleanRoom
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSplitViewDelegate {
	@IBOutlet weak var splitView: NSSplitView!
	
	let sourceList = SourceListController(nibName: "SourceList", bundle: nil)!

	override func awakeFromNib() {
		let leftView = self.splitView.subviews[0] as NSView
		let views = [
			"sourceList": sourceList.view,
		]
		leftView.addSubview(sourceList.view)
		leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sourceList]|", options: nil, metrics: nil, views: views))
		leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sourceList]|", options: nil, metrics: nil, views: views))
	}
	
	func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
		return subview == splitView.subviews[0] as NSObject
	}
}
