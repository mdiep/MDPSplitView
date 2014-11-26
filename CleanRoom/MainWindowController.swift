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
		sourceList.view.frame = leftView.frame
		leftView.removeFromSuperview()
		splitView.addSubview(sourceList.view, positioned: .Below, relativeTo: (splitView.subviews[0] as NSView))
	}
	
	func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
		return subview == splitView.subviews[0] as NSObject
	}
	
	@IBAction func toggleSourceList(sender: AnyObject?) {
		let isOpen = !splitView.isSubviewCollapsed(splitView.subviews[0] as NSView)
		let position = (isOpen ? 0 : lastWidth)
		
		(self.window?.contentView as NSView).wantsLayer = true
		(self.window?.contentView as NSView).displayIfNeeded() // avoids funky implicit animations on the position of the label, &c.

		if isOpen {
			lastWidth = sourceList.view.frame.size.width
		}
		
		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			context.duration = self.duration
			
			self.splitView.setPosition(position, ofDividerAtIndex: 0)
		}, completionHandler: { () -> Void in
			(self.window?.contentView as NSView).wantsLayer = false
		})
	}
}
