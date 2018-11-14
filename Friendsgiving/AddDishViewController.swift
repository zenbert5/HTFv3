//
//  AddDishViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/14/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class AddDishViewController: UIViewController {

    var delegate: EventsDelegate?
    var eventId: String?
    
    @IBOutlet weak var newDish: UITextField!
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.dismissed(reload: false)
    }
    
    @IBAction func saveDish(_ sender: UIBarButtonItem) {
        let url = URL(string: "http://localhost:8000/addDishByEvent/" + eventId!)!

        let jsonData = [
            "label" : newDish.text!
            ] as [String : Any]

        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.allHTTPHeaderFields = [ "Content-Type": "application/json" ]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData)

        let task = session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in

            if let userAddRes = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: userAddRes, options: [])
                    print(json)

                    //self.delegate?.addAnEvent(json as! Dictionary<String, Any>)
                } catch {
                    print(error)
                }
            }

            DispatchQueue.main.async {
                self.delegate?.dismissed(reload: true)
            }
        })
        task.resume()

    }
    
    @IBOutlet weak var newDishName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
