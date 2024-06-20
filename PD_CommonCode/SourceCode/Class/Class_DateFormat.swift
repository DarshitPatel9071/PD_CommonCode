//
//  Class_DateFormat.swift
//  Bibal
//
//  Created by Darshit Patel on 22/05/23.
//

import Foundation

public class DateFormat{
    
    enum FORMAT:String{
        case UTC = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case DateTime_12 = "dd/MM/yyyy hh:mm a"
        
        case Time_24 = "HH:mm"
        
        case PasswordList = "dd/MM/yy HH:mm:ss"
    }
    
    fileprivate class func DF(_ format:FORMAT) -> DateFormatter{
        let df = DateFormatter()
        df.locale = .current
        df.timeZone = format == .UTC ? TimeZone(abbreviation: "UTC") : .current
        df.dateFormat = format.rawValue
        return df
    }
    
    class func To_String(format:FORMAT,date:Date) -> String{
        return DF(format).string(from: date)
    }
    
    class func To_Date(format:FORMAT,string:String) -> Date{
        return DF(format).date(from: string) ?? Date()
    }
    
    class func To_Date(format:FORMAT,date:Date) -> Date{
        let df = DF(format)
        let strDate = df.string(from: date)
        return df.date(from: strDate) ?? Date()
    }
    
    class func From_UTC(format:FORMAT,date:String) -> String{
        let utcDate = DF(.UTC).date(from: date) ?? Date()
        return To_String(format: format, date: utcDate)
    }
    
    class func getTimeStamp() -> TimeInterval{
        let timestamp = NSDate().timeIntervalSince1970
        return timestamp
    }
    
}
