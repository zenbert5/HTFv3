//
//  EventsTableViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    let url = URL(string: "http://localhost:8000/events")!
    
    var userInfo: HotPotato?
    
    var eventsData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 110
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        //request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            
            if let eventData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: eventData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print(json)
                        self.eventsData = json
                        if let data = self.eventsData {
                            print(data)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let objCount = eventsData {
            return objCount.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCellTableViewCell
        
//        cell.eventName.text = [indexPath.row]
//        cell.eventHost.text = hosts[indexPath.row]
//        cell.eventDate.text = hosts[indexPath.row]

        return cell
    }
}

