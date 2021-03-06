/*
 Copyright (c) 2016, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CareKit
import ResearchKit

/**
 Struct that conforms to the `Assessment` protocol to define a back pain
 assessment.
 */
struct BackPain: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .backPain
    
    func carePlanActivity() -> OCKTask? {
        // Create a weekly schedule.
        let startDate = (UserDefaults.standard.object(forKey: "startDate") as! Date)
        
        let occurrences = [1, 1, 1, 1, 1, 1, 1]
        var scheduleElements : [OCKScheduleElement] = []
        
        for index in 0..<occurrences.count {
            
            if occurrences[index] == 1 {
                let caldendar = Calendar.current
                let startOfDay = Calendar.current.startOfDay(for: startDate)
                let scheduleStartDate = caldendar.date(byAdding: .day, value: index, to: startOfDay)!
                
                let scheduleElement =  OCKScheduleElement(start: scheduleStartDate, end: nil,
                                                          interval: DateComponents(day: 28),
                                                          text: "Lower Back",
                                                          targetValues: [],
                                                          duration: .allDay)
                scheduleElements.append(scheduleElement)
            }
        }
        
        let schedule = OCKSchedule(composing: scheduleElements)
        var activity = OCKTask(id: activityType.rawValue,
                               title: "Pain",
                               carePlanID: nil, schedule: schedule)
        
        activity.groupIdentifier = "Diagnostics"
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        
        var steps = [ORKStep]()
        
        // Get the localized strings to use for the task.
        let question = NSLocalizedString("What was your average pain in the last 24 hours?", comment: "")
        let maximumValueDescription = NSLocalizedString("Worst pain imaginable", comment: "")
        let minimumValueDescription = NSLocalizedString("No pain", comment: "")
        
        // Create a question and answer format.
        let answerFormat = ORKScaleAnswerFormat(
            maximumValue: 10,
            minimumValue: 0,
            defaultValue: -1,
            step: 1,
            vertical: false,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
        
        let questionStep = ORKQuestionStep(identifier: "backPainStep1",
                                           title: question,
                                           question: question,
                                           answer: answerFormat)
        questionStep.isOptional = false
        steps += [questionStep]
        
        // Get the localized strings to use for the task.
        let question2 = NSLocalizedString("What was your maximum pain in the last 24 hours?", comment: "")
        let questionStep2 = ORKQuestionStep(identifier: "backPainStep2",
                                            title: question2,
                                            question: question2,
                                            answer: answerFormat)
        questionStep2.isOptional = false
        
        steps += [questionStep2]
        
//        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
//        summaryStep.title = "Thank you."
//        summaryStep.text = "We appreciate your time."
//        
//        steps += [summaryStep]
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: steps)
        
        return task
    }
}
