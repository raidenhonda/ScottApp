//
//  TicketFetch.swift
//  Scott
//
//  Created by Raiden Honda on 11/10/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class TechnicianDataFetch : SyncTask {
    
    var automaticTask: Bool = true
    var docType : String? = nil
    
    func sync(jsonString: String?, success: (() -> ())?) {
        guard let userId = Globals.userId else {
            success?()
            return
        }
        
        // Send web request
        let headerDict = [
            "Authorization" : "Token token=\(PingPong.shared.authorizationToken)"
        ];
        
        let url = "\(PingPong.shared.documentEndpoint)/app/technician/\(userId)"
        
        // Send the request
        request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerDict)
            .validate()
            .responseJSON { response in
                if let value = response.result.value {
                    // Get the swifty json object
                    let json = JSON(value)
                    
                    // Get and save the technician
                    if let techJson = json["technician"].rawString() {
                        let technician = User()
                        technician.fromJSON(json: techJson)
                        technician.stash()
                    }
                    
                    // Get and save the tickets
                    if let tickets = json["tickets"].array {
                        for ticketJson in tickets {
                            let ticket = Ticket()
                            ticket.fromJSON(json: ticketJson.rawString()!)
                            ticket.safeStashFromCloud()
                        }
                        print("Fetched \(tickets.count) tickets")
                    }
                    
                    // Get and save the number of completed tickets
                    if let completedTicketsCount = json["completedTickets"].int {
                        Globals.weeklyCompletedTickets = completedTicketsCount
                    }
                }
        }
    }
}
