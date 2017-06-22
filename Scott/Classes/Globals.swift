//
//  Globals.swift
//  Scott
//
//  Created by Raiden Honda on 22/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation
import UIKit

class Globals {
    // Endpoint Variables
    static var endpoint : String = "https://scott-api-node-dev-scott-api-node.azurewebsites.net/api"
    static var authToken : String = "ae716140-772a-4a60-a005-4f2d28fc21a3";
    
    // Timer Variables
    static var backgroundSyncInterval : Int = 60
    
    static var sColorCellBg     : UIColor = #colorLiteral(red: 0.2196078431, green: 0.2392156863, blue: 0.2588235294, alpha: 1)
    static var sColorNavBg      : UIColor = #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.1882352941, alpha: 1)
    static var sColorYellowText : UIColor = #colorLiteral(red: 0.9529411765, green: 0.8352941176, blue: 0.3882352941, alpha: 1)
    static var sColorBlue       : UIColor = #colorLiteral(red: 0.4078431373, green: 0.7019607843, blue: 0.9882352941, alpha: 1)
    
    static var userId : String? {
        get {
            return UserDefaults.standard.string(forKey: "SignedInUserId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SignedInUserId")
        }
    }
    
    static var weeklyCompletedTickets : Int {
        get {
            return UserDefaults.standard.integer(forKey: "WeeklyCompletedTickets")
        } set {
            UserDefaults.standard.set(newValue, forKey: "WeeklyCompletedTickets")
        }
    }
}

func makeRoundBtn(view: UIView) {
    view.layer.cornerRadius = 5.0
    view.layer.masksToBounds = true
}

func makeRoundIdLabel(view: UIView) {
    view.layer.cornerRadius = 12
    view.layer.borderWidth = 2.0
    view.layer.borderColor = Globals.sColorBlue.cgColor
}
