//
//  EventsDelegate.swift
//  Friendsgiving
//
//  Created by Shawn Chen on 11/13/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

protocol EventsDelegate: class {
    func addAnEvent(_ eventInfo: Dictionary<String, Any>)
}
