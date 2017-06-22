//
//  PayrollWeek.swift
//  Scott
//
//  Created by Raiden Honda on 11/8/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class WeekTime : SyncObject {
    var technicianId : String = ""
    var name : String = ""
    var serviceLocation : String = ""
    var startOfWeek : String = ""
    var days : [ DayTime ] = []
    var docType = "weekTime"
    
    var totalWorkHours : Double {
        get {
            // Calculate Timespans for each day
            let totalTimespan = self.days.reduce(0.0) { (timespan, payrollDay) -> Double in
                let start = Date.fromISOString(dateString: payrollDay.startUtc)
                let end = Date.fromISOString(dateString: payrollDay.endUtc)
                let endDate = end as NSDate
                return timespan + endDate.timeIntervalSince(start)
            }
            
            // A timespan is seconds, so convert and divide to get hours
            return totalTimespan / (60*60)
        }
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
    }
    
    override func fromJSON(json: String) {
        self.days = []
        
        super.fromJSON(json: json)
        
        // Days
        if let dayArray = self.deserializationExceptions["days"]?.array {
            for dayJson in dayArray {
                let day = DayTime()
                day.fromJSON(json: dayJson.rawString()!)
                self.days.append(day)
            }
        }
    }
    
    static func currentWeek() -> WeekTime? {
        let sema = DispatchSemaphore(value: 0)
        var week : WeekTime?
        
        // Get current week
        let monday = Date.lastMonday()
        let mondayString = monday.toShortDateString()
        DataStore.sharedDataStore.queryDocumentStore(parameters: ("docType", "weekTime"), ("startOfWeek", mondayString)) { json in
            if json.count > 0 {
                week = WeekTime()
                week!.fromJSON(json: json[0].rawString()!)
            }
            sema.signal()
        }
        sema.wait()
        
        return week
    }
    
    static func currentDay() -> DayTime? {
        // Get the current week, may not exist
        if let weekTime = WeekTime.currentWeek() {
            // Get localized date string
            let today = Date().localDate().toShortDateString()
            
            // Get the day index, otherwise return nil
            if let dayIndex = weekTime.days.index(where: { $0.date == today }) {
                return weekTime.days[dayIndex]
            } else {
                return nil
            }
        } else {
            // Week has not been created therefore there is no day
            return nil
        }
    }
    
    static func updateCurrentTime(startTime : String?, endTime : String?) {
        // Get the current week, may not exist
        if let weekTime = WeekTime.currentWeek() {
            // Get localized date string
            let today = Date().localDate().toShortDateString()
            
            // Get the day index, otherwise return nil
            if let dayIndex = weekTime.days.index(where: { $0.date == today }) {
                if let startTimeValue = startTime {
                    weekTime.days[dayIndex].startUtc = startTimeValue
                }
                if let endTimeValue = endTime {
                    weekTime.days[dayIndex].endUtc = endTimeValue
                }
                weekTime.saveEventually()
            }
        }
    }
}
