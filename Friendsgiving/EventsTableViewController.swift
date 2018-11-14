//
//  EventsTableViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var events = ["Event", "Event2", "Event3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 110

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCellTableViewCell
        
        cell.eventName.text = events[indexPath.row]

        return cell
    }
}

