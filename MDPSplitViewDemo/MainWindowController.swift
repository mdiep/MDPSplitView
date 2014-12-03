//
//  MainWindowController.swift
//  CleanRoom
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSplitViewDelegate {
    @IBOutlet weak var splitView: MDPSplitView!
    
    let sourceList = SourceListController(nibName: "SourceList", bundle: nil)!
    var lastWidth: CGFloat = 100
    var duration: NSTimeInterval = 0.5
    var widthConstraint: NSLayoutConstraint?
    var animatingSidaber = false

    override func awakeFromNib() {
        let leftView = self.splitView.subviews[0] as NSView
        let views = [
            "sourceList": sourceList.view,
            "leftView": leftView,
        ]
        leftView.addSubview(sourceList.view)
        leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sourceList(==leftView@250,>=150@1000)]", options: nil, metrics: nil, views: views))
        leftView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sourceList]|", options: nil, metrics: nil, views: views))
        
        widthConstraint = NSLayoutConstraint(item: sourceList.view, attribute: .Trailing, relatedBy: .Equal, toItem: leftView, attribute: .Trailing, multiplier: 1, constant: 0)
        leftView.addConstraint(widthConstraint!)
    }
    
    func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return subview == splitView.subviews[0] as NSObject
    }
    
    func splitViewDidResizeSubviews(notification: NSNotification) {
        if !animatingSidaber {
            let leftView = self.splitView.subviews[0] as NSView
            if !self.splitView.isSubviewCollapsed(leftView) {
                let constraints = leftView.constraints as NSArray
                if !constraints.containsObject(widthConstraint!) {
                    leftView.addConstraint(widthConstraint!)
                }
            }
        }
    }

    @IBAction func toggleSourceList(sender: AnyObject?) {
        if animatingSidaber {
            return
        }
        
        let sourceView = splitView.subviews[0] as NSView
        let detailView = splitView.subviews[1] as NSView
        let isOpen = !splitView.isSubviewCollapsed(sourceView)
        let position = (isOpen ? 0 : lastWidth)

        sourceView.removeConstraint(widthConstraint!)
        
        if isOpen {
            lastWidth = sourceList.view.frame.size.width
        } else {
            sourceView.frame.size.width = 0
        }

        animatingSidaber = true
        
        NSAnimationContext.runAnimationGroup({ context in
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            context.duration = self.duration

            self.splitView.setPosition(position, ofDividerAtIndex: 0, animated: true)
        }, completionHandler: {
            self.animatingSidaber = false
            if !isOpen {
                sourceView.addConstraint(self.widthConstraint!)
            }
        })
    }
}
