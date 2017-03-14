//
//  UTCDateTime.swift
//  FelineFitness
//
//  Created by Huijing on 08/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


extension Date{

    func toMillis() -> NSNumber {
        return NSNumber(value:Int64(timeIntervalSince1970 * 1000))
    }

    static func fromMillis(millis: NSNumber?) -> Date? {
        return millis.map() { number in NSDate(timeIntervalSince1970: Double(number) / 1000) as Date}
    }

    static func currentTimeInMillis(_ date: Date) -> NSNumber {
        return date.toMillis()
    }


    static func toLocalMillis(globalMillis: NSNumber) -> NSNumber{
        let tz = NSTimeZone.local
        let differenceSeconds = tz.secondsFromGMT()
        return NSNumber(value: globalMillis.int64Value + differenceSeconds*1000)
    }

    static func getCurrentTimeFromGlobalMillis(millis: Int64) -> Date
    {
        return Date.fromMillis(millis: Date.toLocalMillis(globalMillis: NSNumber(value: millis)))!
    }
    
    static func getDayOfWeek(today:String)->Int? {
        let dateTimes = today.components(separatedBy: " ")
        let todayString = dateTimes[0]
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: todayString) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }
    
    static func getTime(_ dateString: String) -> (String, String, String){
        
        var hour = ""
        var minute = ""
        var second = ""
        let dateItems = dateString.components(separatedBy: " ")
        if dateItems.count > 1{
            let timeString = dateItems[1]
            let timeItems = timeString.components(separatedBy: ":")
            if timeItems.count > 2{
                hour = timeItems[0]
                minute = timeItems[1]
                second = timeItems[2]
            }
        }
        
        return (hour, minute, second)
    }
    
    static func getDate(_ dateString: String) -> (String, String, String){
        var year = ""
        var month = ""
        var day = ""
        let dateItems = dateString.components(separatedBy: " ")
        if dateItems.count > 1{
            let dayString = dateItems[1]
            let dayItems = dayString.components(separatedBy: "-")
            if dayItems.count > 2{
                year = dayItems[0]
                month = dayItems[1]
                day = dayItems[2]
            }
        }
        
        
        return (year, month, day)

    }

}



func getGlobalTime() -> Int64
{
    return Date().toMillis().int64Value
}

func getTimeStringfromGMTTimeMillis(time: Int64) -> Date
{
    return Date.getCurrentTimeFromGlobalMillis(millis: time)
}

