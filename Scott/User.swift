//
//  User.swift
//  Scott
//
//  Created by Raiden Honda on 11/8/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class User : StashObject {
    var docType : String = "user"
    var name : String = ""
    var role : String = ""
    var email : String = ""
    var serviceLocation : String = ""
    
    override var description : String {
        get {
            return "Name: \(name) Role: \(role)";
        }
    }
    
    static func getCurrentTechnician() -> User? {
        guard let userId = Globals.userId else {
            return nil
        }
        
        let sema = DispatchSemaphore(value: 0)
        
        let currentTechnician = User()
        DataStore.sharedDataStore.retrieveDocumentJSON(id: userId) { jsonString in
            if let strongJson = jsonString {
                currentTechnician.fromJSON(json: strongJson)
                sema.signal()
            }
        }
        
        sema.wait()
        return currentTechnician
    }
}
