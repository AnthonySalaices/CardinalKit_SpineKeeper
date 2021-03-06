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

import ResearchKit
import CareKit

/**
 Struct that conforms to the `Assessment` protocol to define a blood glucose
 assessment.
 */
struct VoiceAnalysis: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .voiceAnalysis
    
    func carePlanActivity() -> OCKTask? {
        return nil
    }
    
    /* Junaid Commnented
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2016, month: 01, day: 01)
        let endDate = DateComponents(year: 2018, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1], weeksToSkip: 0, endDate: endDate)
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Voice Analysis", comment: "")
        let summary = NSLocalizedString("Read a short sentance to record a voice clip.", comment: "")
        let activity = OCKCarePlanActivity.assessment(
            withIdentifier: activityType.rawValue,//+startDate.description+endDate.description,
            groupIdentifier: activityType.rawValue,
            title: title,
            text: summary,
            tintColor: Colors.stanfordAqua.color,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil,
            optional: false
        )
        return activity
    }
 
 */
    // MARK: Assessment
    func task() -> ORKTask {
        let intendedUseDescription = "Everyone's voice has unique characteristics."
        let speechInstruction = "After the countdown, please read the following sentance at a moderate pace: 'The quick brown fox jumps over the lazy dog.' You'll have 10 seconds."
        let shortSpeechInstruction = "Read outloud: 'The quick brown fox jumps over the lazy dog'."
        
        
        return ORKOrderedTask.audioTask(withIdentifier: "AudioTask", intendedUseDescription: intendedUseDescription, speechInstruction: speechInstruction, shortSpeechInstruction: shortSpeechInstruction, duration: 15, recordingSettings: nil, checkAudioLevel: false, options: ORKPredefinedTaskOption.excludeAccelerometer)

    }
}
