//
//  Job.swift
//  Scott
//
//  Created by Raiden Honda on 11/8/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class Ticket : SyncObject {
    // Identification
    var docType : String = "ticket"; // This field is for querying on type
    
    // Ticket Fields
    var customerId : String = ""
    var customerName : String = ""
    var poNumber : String = ""
    var woNumber : String = ""
    var status : String = ""
    var workDescription : String = ""
    var technicians : [ TicketTechnician ] = []
    var technicalNote : String = ""
    var materialList : [ MaterialItem ] = []
    var checkList : [ CheckListItem ] = [];
    var workCompleted : String = "";
    var signatureName : String = ""
    var signatureImageUrl : String = ""
    
    // Work Days
    var workDays : [ DayTime ] = [];
    
    // Date Fields
    var dateOpened : String = ""
    var jobStart : String = ""
    var jobEnd : String = ""
    var signatureDate : String = ""
    
    override var description : String {
        get {
            return "Customer: \(customerName) \nJobNumber: \(poNumber) \nJobStart: \(jobStart) \nJobEnd: \(jobEnd) \nStatus: \(status)";
        }
    }
    
    override func fromJSON(json: String) {
        self.technicians = []
        self.workDays = []
        
        super.fromJSON(json: json)
        
        // Technicians
        if let techArray = self.deserializationExceptions["technicians"]?.array {
            for techJson in techArray {
                let techTicket = TicketTechnician()
                techTicket.fromJSON(json: techJson.rawString()!)
                self.technicians.append(techTicket)
            }
        }
        
        // Material List
        if let materialArray = self.deserializationExceptions["materialList"]?.array {
            for itemJson in materialArray {
                let materialItem = MaterialItem()
                materialItem.fromJSON(json: itemJson.rawString()!)
                self.materialList.append(materialItem)
            }
        }
        
        // Check List
        if let checkListArray = self.deserializationExceptions["checkList"]?.array {
            for json in checkListArray {
                let item = CheckListItem()
                item.fromJSON(json: json.rawString()!)
                self.checkList.append(item)
            }
        }
        
        // Work Days
        if let daysArray = self.deserializationExceptions["workDays"]?.array {
            for json in daysArray {
                let item = DayTime()
                item.fromJSON(json: json.rawString()!)
                self.workDays.append(item)
            }
        }
    }
    
    func indexOfCurrentDay() -> Int? {
        // Get localized date string
        let today = Date().localDate().toShortDateString()
        
        // Get the day index, otherwise return nil
        if let dayIndex = self.workDays.index(where: { $0.date == today }) {
            return dayIndex
        } else {
            return nil
        }
    }
}
