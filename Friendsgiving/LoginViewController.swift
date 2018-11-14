//
//  ViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, RegisterDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var thisUser = [HotPotato]()
    
    @IBOutlet weak var emailInputBox: UITextField!
    @IBOutlet weak var passwordInputBox: UITextField!
    
    @IBAction func userClickLogin(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkUserExist()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navController = segue.destination as! UINavigationController
//
//        if segue.identifier == "newUserSegue" {
//            _ = navController.topViewController as! RegisterViewController
//        }
//
//        if segue.identifier == "loginSegue" {
//            let destination = navController.topViewController as! EventsTableViewController
//            destination.userInfo = thisUser[0]
//        }
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let addDestination = navController.topViewController as! RegisterViewController
        addDestination.delegate = self
    }
    
    func checkUserExist() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HotPotato")
        do {
            let result = try managedObjectContext.fetch(request)
            thisUser = result as! [HotPotato]
            if thisUser.count == 0 {
                print("no user")
                
            }
        } catch {
            print("\(error)")
        }
    }
    
    func dismissed() {
        dismiss(animated: true, completion: nil)
    }

}

