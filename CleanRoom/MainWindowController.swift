//
//  MainWindowController.swift
//  CleanRoom
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSplitViewDelegate {
	@IBOutlet weak var splitView: AnimatableSplitView!
	
	let sourceList = SourceListController(nibName: "SourceList", bundle: nil)!
	var lastWidth: CGFloat = 100
	var duration: NSTimeInterval = 0.5

	override func awakeFromNib() {
		let leftView = self.splitView.subviews[0] as NSView
		let views = [
			"sourceList": sourceList.view,
			"leftView": leftView,
		]
		leftView.addSubview(sourceList.view)
		leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sourceList(==leftView@250,>=150@1000)]", options: nil, metrics: nil, views: views))
		leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sourceList]|", options: nil, metrics: nil, views: views))
	}
	
	func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
		return subview == splitView.subviews[0] as NSObject
	}

	@IBAction func toggleSourceList(sender: AnyObject?) {
		let sourceView = splitView.subviews[0] as NSView
		let detailView = splitView.subviews[1] as NSView
		let isOpen = !splitView.isSubviewCollapsed(sourceView)
		let position = (isOpen ? 0 : lastWidth)

		if isOpen {
			lastWidth = sourceList.view.frame.size.width
		}

		NSAnimationContext.runAnimationGroup({ context in
			context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			context.duration = self.duration

			self.splitView.animator().splitPosition = position
		}, completionHandler: { () -> Void in
		})
	}
}


/// Not `final` because if it is, the animation methods are not called.
class AnimatableSplitView: NSSplitView {
	override class func defaultAnimationForKey(key: String) -> AnyObject? {
		if key == "splitPosition" {
			return CABasicAnimation()
		}
		return super.defaultAnimationForKey(key)
	}

	override func isSubviewCollapsed(subview: NSView) -> Bool {
		// fixme: this doesn’t track whether the splitPosition is currently animating to 0, and it should
		return splitPosition <= 1
	}

	// fixme: using a computed property allowed us to collapse but not expand, but using a stored property means we can fall out of sync with user drags
	dynamic var splitPosition: CGFloat = 150 {
		didSet {
			setPosition(splitPosition, ofDividerAtIndex: 0)
		}
	}

	// fixme: dragging to a suitably small size should collapse
}
