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
    
    let url = URL(string: "http://localhost:8000/addUser")!
    

    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    
    @IBAction func userPressedRegister(_ sender: UIButton) {
        
        let jsonData = [
            //"name" : newUserName.text,
            "email" : newUserEmail.text,
            "password" : newUserPassword.text
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
            // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
            // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
            print(data as Any)
        })
        task.resume()
    }

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
