//
//  EventsTableViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, EventsDelegate {

    let url = URL(string: "http://localhost:8000/events")!
    
    var userInfo: [HotPotato]?
    var delegate: EventsTableDelegate?
    var eventsData = [Dictionary<String, Any>]()
    
    @IBOutlet var eventsTableView: UITableView!
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        delegate?.dismissed()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 110
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        //request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            
            print("fetching events data")
            if let eventData = data {
                print("eventData = ", eventData)
                do {
                    if let json = try JSONSerialization.jsonObject(with: eventData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Dictionary<String, Any>] {
                        print(json)
                        print(json[0])
                        self.eventsData = json
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
        return eventsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCellTableViewCell
        
        let displayData = eventsData
        print("here")
        cell.eventName.text = displayData[indexPath.row]["title"] as? String
        cell.eventHost.text = displayData[indexPath.row]["title"] as? String
        cell.eventDate.text = displayData[indexPath.row]["location"] as? String
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as! UINavigationController
        
        if let destination = nc.topViewController as? AddEventViewController {
            destination.delegate = self
        } else if let destination = nc.topViewController as? DetailsViewController {
            destination.delegate = self
        }
    }
    
    func dismissed(reload: Bool) {
        dismiss(animated: true, completion: nil)
        if reload {
            self.viewDidLoad()
        }
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetailsSegue", sender: nil)
    }
}

