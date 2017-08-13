//
//  MainWindowController.swift
//  MDPSplitViewDemo
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSplitViewDelegate {
    @IBOutlet weak var splitView: MDPSplitView!
    
    let sourceList = SourceListController(nibName: "SourceList", bundle: nil)!
    let infoPane   = InfoPaneController(nibName: "InfoPane", bundle: nil)!
    
    var lastSourceWidth: CGFloat = 100
    var sourceWidthConstraint: NSLayoutConstraint?
    
    var lastInfoWidth: CGFloat = 100
    var infoWidthConstraint: NSLayoutConstraint?
    
    var duration: TimeInterval = 0.5
    
    var leftView: NSView {
        return self.splitView.subviews[0] as NSView
    }
    var rightView: NSView {
        return self.splitView.subviews[2] as NSView
    }

    override func awakeFromNib() {
        let views = [
            "sourceList": sourceList.view,
            "infoPane":   infoPane.view,
        ]
        
        leftView.addSubview(sourceList.view)
        leftView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sourceList]-(0@250)-|", options: [], metrics: nil, views: views))
        leftView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sourceList]|", options: [], metrics: nil, views: views))
        
        sourceWidthConstraint = NSLayoutConstraint(item: sourceList.view, attribute: .trailing, relatedBy: .equal, toItem: leftView, attribute: .trailing, multiplier: 1, constant: 0)
        leftView.addConstraint(sourceWidthConstraint!)
        
        rightView.addSubview(infoPane.view)
        rightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0@250)-[infoPane]|", options: [], metrics: nil, views: views))
        rightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[infoPane]|", options: [], metrics: nil, views: views))
        
        infoWidthConstraint = NSLayoutConstraint(item: infoPane.view, attribute: .leading, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: 0)
        rightView.addConstraint(infoWidthConstraint!)
    }
    
    func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return subview == leftView || subview == rightView
    }
    
    func splitViewDidResizeSubviews(_ notification: Notification) {
        if !splitView.isAnimatingDivider(at: 0) {
            if !self.splitView.isSubviewCollapsed(leftView) {
                let constraints = leftView.constraints as NSArray
                if !constraints.contains(sourceWidthConstraint!) {
                    leftView.addConstraint(sourceWidthConstraint!)
                }
            }
        }
        
        if !splitView.isAnimatingDivider(at: 1) {
            if !self.splitView.isSubviewCollapsed(rightView) {
                let constraints = rightView.constraints as NSArray
                if !constraints.contains(infoWidthConstraint!) {
                    rightView.addConstraint(infoWidthConstraint!)
                }
            }
        }
    }

    @IBAction func toggleSourceList(_ sender: AnyObject?) {
        if splitView.isAnimatingDivider(at: 0) {
            return
        }
        
        let isOpen = !splitView.isSubviewCollapsed(leftView)
        let position = (isOpen ? 0 : lastSourceWidth)

        leftView.removeConstraint(sourceWidthConstraint!)
        
        if isOpen {
            lastSourceWidth = sourceList.view.frame.size.width
        } else {
            leftView.frame.size.width = 0
        }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            context.duration = self.duration

            self.splitView.setPosition(position, ofDividerAt: 0, animated: true)
        }, completionHandler: {
            if !isOpen {
                self.leftView.addConstraint(self.sourceWidthConstraint!)
            }
        })
    }
    
    @IBAction func toggleInfoPane(_ sender: AnyObject?) {
        if splitView.isAnimatingDividerAtIndex(1) {
            return
        }
        
        let isOpen = !splitView.isSubviewCollapsed(rightView)
        let position = splitView.frame.size.width - (isOpen ? 0 : lastInfoWidth)
        
        rightView.removeConstraint(infoWidthConstraint!)
        
        if isOpen {
            lastInfoWidth = infoPane.view.frame.size.width
        } else {
            rightView.frame.size.width = 0
        }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            context.duration = self.duration
            
            self.splitView.setPosition(position, ofDividerAtIndex: 1, animated: true)
        }, completionHandler: {
            if !isOpen {
                self.rightView.addConstraint(self.infoWidthConstraint!)
            }
        })
    }
}
