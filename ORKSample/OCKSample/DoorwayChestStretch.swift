//
//  PressUp.swift
//  ORKSample
//
//  Created by Aman Sinha on 11/15/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import CareKit
import UIKit

/**
 Struct that conforms to the `Activity` protocol to define a press up
 activity.
 */
struct DoorwayChestStretch: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .doorwayChestStretch
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        var days: [Int] = []
        switch(UserDefaults.standard.integer(forKey: "activityScheduleIndex")) {
        case 0:
            days = [11,14,16,18,20,22,24,26,28]
            break;
        case 1:
            days = []
            break;
        case 2:
            days = []
            break;
        default:
            days = []
        }
        
        if days.count == 0 {
            return nil
        }
        
        var occurrences = [Int](repeating: 0, count: 28)
        for day in days {
            occurrences[day-1]+=2
        }
        
        var schedules : [OCKSchedule] = []
        
        for index in 0..<occurrences.count {
            
            if occurrences[index] == 2 {
                let caldendar = Calendar.current
                let startOfDay = Calendar.current.startOfDay(for: startDate)
                var scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
                scheduleStartDate = caldendar.date(byAdding: .hour, value: 6, to: scheduleStartDate)!
                                
                let scheduleElement1 =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Repeat 2-3 times daily",
                                                          targetValues: [],
                                                          duration: .hours(1))
                
                let subSchedule1 = OCKSchedule(composing: [scheduleElement1])
                
                scheduleStartDate = caldendar.date(byAdding: .hour, value: 11, to: scheduleStartDate)!
                let scheduleElement2 =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Repeat 2-3 times daily",
                                                          targetValues: [],
                                                          duration: .hours(1))
                let subSchedule2 = OCKSchedule(composing: [scheduleElement2])
                
                schedules.append(subSchedule1)
                schedules.append(subSchedule2)
            }
        }
        
        let schedule = OCKSchedule(composing: schedules)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Doorway Chest Stretch",
                               carePlanID: nil, schedule: schedule)
        
        activity.instructions = "Stand in a doorway placing your arms as shown and with your back straight. Step through the door to feel a stretch in your chest area. Moving your hands higher or lower will allow you to stretch more areas of the chest. Do this for 10-15 seconds."
        
        activity.groupIdentifier = "Todo's"
        activity.asset = "doorwaycheststretch.jpg"
        return activity
    }
}


