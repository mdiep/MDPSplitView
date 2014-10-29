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
	var lastWidth: CGFloat = 100
	var duration: NSTimeInterval = 0.5

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
	
	@IBAction func toggleSourceList(sender: AnyObject?) {
		let isOpen = !splitView.isSubviewCollapsed(sourceList.view.superview!)
		let position = (isOpen ? 0 : lastWidth)
		
		if isOpen {
			lastWidth = sourceList.view.frame.size.width
		}
		
		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
			context.duration = self.duration
			
			self.splitView.setPosition(position, ofDividerAtIndex: 0)
		}, completionHandler: { () -> Void in
		})
	}
}
