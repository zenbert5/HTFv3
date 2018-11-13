//
//  ViewController.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
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

}

