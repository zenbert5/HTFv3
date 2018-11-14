//
//  ViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, RegisterDelegate, EventsTableDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var thisUser:HotPotato?
    
    @IBOutlet weak var emailInputBox: UITextField!
    @IBOutlet weak var passwordInputBox: UITextField!
    
    @IBAction func userClickLogin(_ sender: UIButton) {
        
        if let email = emailInputBox.text {
            let url = URL(string: "http://localhost:8000/getUser/" + email)!
            print("fetching user with url ->", url)
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: {
                // see: Swift closure expression syntax
                data, response, error in
                
                if let userData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any>
                        
                        self.thisUser = HotPotato(context: self.managedObjectContext)
                        
                        self.thisUser!.name = json["name"] as? String
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        }

                        print(json)
                        
                        
                    } catch {
                        print(error)
                    }
                }
            })
            
            task.resume()
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkUserExist()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController

        if segue.identifier == "loginToRegister" {
            print("segue to register from login")
            let destination = navController.topViewController as! RegisterViewController
            destination.delegate = self
        }

        if segue.identifier == "loginSegue" {
            let destination = navController.topViewController as! EventsTableViewController
            print("This User Name:", thisUser!.name)
            destination.userInfo = thisUser
            destination.delegate = self
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navController = segue.destination as! UINavigationController
//        let addDestination = navController.topViewController as! RegisterViewController
//        addDestination.delegate = self
//    }
    
    func checkUserExist() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HotPotato")
        do {
            let result = try managedObjectContext.fetch(request)
            thisUser = (result as! [HotPotato]).first
        } catch {
            print("\(error)")
        }
    }
    
    func dismissed() {
        dismiss(animated: true, completion: nil)
    }

    func registerUser(_ newUserInput: Dictionary<String, Any>) {
        let url = URL(string: "http://localhost:8000/addUser")!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.allHTTPHeaderFields = [ "Content-Type": "application/json" ]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: newUserInput)
        print("http json format --> ", request.httpBody!)
        
        session.dataTask(with: request, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            
            if let userAddRes = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: userAddRes, options: [])
                    print(json)
                    self.performSegue(withIdentifier: "RegisterToEvents", sender: self)
                } catch {
                    print(error)
                }
            }
        })
        dismissed()
    }
    
}

