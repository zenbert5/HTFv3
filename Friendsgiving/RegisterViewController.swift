//
//  registerViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

var response: Any?

class RegisterViewController: UIViewController {
    
   // let url = URL(string: "http://localhost:8000/addUser")!
    
    var delegate: RegisterDelegate?

    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    
    
    @IBAction func cancelRegistration(_ sender: UIBarButtonItem) {
        // delegate?.dismissed()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userPressedRegister(_ sender: UIButton) {
        
        print("user pressed register button")
        let jsonData = [
            "name" : newUserName.text,
            "email" : newUserEmail.text,
            "password" : newUserPassword.text
        ]
        
//        delegate?.registerUser(jsonData as Dictionary<String, Any>)
        let url = URL(string: "http://localhost:8000/addUser")!
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
                    
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("arrived at register view controller")
        // Do any additional setup after loading the view.
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navController = segue.destination as! UINavigationController
//        let destination = navController.topViewController as! EventsTableViewController
//        if segue.identifier == "RegisterToEvents" {
//            if let userData = sender as? HotPotato {
//                destination.userInfo = userData
//            }
//        }
//    }
    
}
