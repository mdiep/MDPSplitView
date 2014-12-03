//
//  SourceListController.swift
//  CleanRoom
//
//  Created by Matt Diephouse on 10/29/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

import Cocoa

class SourceListController: NSViewController, NSTableViewDataSource {
    let books = [
        "The Cat's Pajamas",
        "Dandelion Wine",
        "Death is a Lonely Business",
        "Driving Blind",
        "Fahrenheit 451",
        "Farewell Summer",
        "From the Dust Returned",
        "A Graveyard for Lunatics",
        "Green Shadows, White Whale",
        "The Illustrated Man",
        "I Sing the Body Electric!",
        "Let's All Kill Constance",
        "The Martian Chronicles",
        "A Medicine for Melancholy",
        "Now and Forever",
        "The October Country",
        "One More For the Road",
        "Quicker Than the Eye",
        "Something Wicked This Way Comes",
    ]
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return books.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return books[row]
    }
}
