//
//  AddEventViewController.swift
//  Friendsgiving
//
//  Created by Shawn Chen on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    var delegate: EventsDelegate?
    let url = URL(string: "http://localhost:8000/addEvent")!
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventDate: UIDatePicker!
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
    
        let jsonData: Dictionary<String, Any> = [
            "title" : eventName.text!,
            //"hostId : newUserEmail.text,
            "location": eventLocation.text!,
            "schedule" : eventDate.date
        ]
        
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.allHTTPHeaderFields = [ "Content-Type": "application/json" ]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData)
        print("http json format --> ", request.httpBody!)
        
        let task = session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            
            if let userAddRes = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: userAddRes, options: [])
                    print(json)
                    
                    self.delegate?.addAnEvent(json as! Dictionary<String, Any>)
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    
    }
    
    @objc func newDateHandler(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "MM dd, yyyy"
        
        let strDateTime = timeFormatter.string(from: eventDate.date)
        let strDateDate = dateFormatter.string(from: eventDate.date)
        print(strDateDate, strDateTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventDate.addTarget(self, action: #selector(newDateHandler), for: UIControl.Event.valueChanged)
    }
    


}