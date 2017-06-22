//
//  TicketTechnician.swift
//  Scott
//
//  Created by Raiden Honda on 11/8/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class TicketTechnician : JsonObject {
    var technician : User = User()
    var role : String = ""
    
    init(technician : User, role : String) {
        super.init()
        
        self.technician = technician
        self.role = role
    }
    
    override init() {
        super.init()
    }
    
    override func fromJSON(json: String) {
        super.fromJSON(json: json)
        
        if let techJson = self.deserializationExceptions["technician"] {
            self.technician.fromJSON(json: techJson.rawString()!)
        }
    }
}
