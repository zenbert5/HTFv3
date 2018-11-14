//
//  DetailsViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/14/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, EventsDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventUserLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    var delegate: EventsDelegate?
    var event = Dictionary<String, Any>()
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        eventNameLabel.text = event["title"] as? String
        eventUserLabel.text = event["name"] as? String
        eventLocationLabel.text = event["location"] as? String
        eventDateLabel.text = event["schedule"] as? String
        
        // Do any additional setup after loading the view
        let url = URL(string: "http://localhost:8000/getDishes/" + (event["_id"] as! String))!
        print(event["_id"] as! String)
       
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            
            if let userAddRes = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: userAddRes, options: [])
                    print(json)
                    
                    let dishesJson = (json as! Dictionary<String,Any>)["dishes"]
                    self.event["dishes"] = dishesJson
                    
                    DispatchQueue.main.async {
                        print("Dishes Count (1):", (self.event["dishes"] as! [Dictionary<String, Any>]).count)

                        self.detailsTableView.reloadData()
                    }
                    
                    //self.delegate?.addAnEvent(json as! Dictionary<String, Any>)
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate!.dismissed(reload: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as! UINavigationController
        let destination = nc.topViewController as! AddDishViewController
        destination.delegate = self
        destination.eventId = (event["_id"] as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event["dishes"] as! [Dictionary<String, Any>]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as! DishTableViewCell
        
        let dish = (event["dishes"] as! [Dictionary<String, Any>])[indexPath.row]
        print("Dishes Count:", (event["dishes"] as! [Dictionary<String, Any>]).count)
        cell.dishLabel.text = dish["label"] as? String
        //cell.userDishLabel.text = event["dishes"][IndexPath.row]["submitted"]
        
        return cell
    }
    
    
    func dismissed(reload: Bool) {
        dismiss(animated: true, completion: nil)
        if reload {
            viewDidLoad()
        }
    }
    
}
