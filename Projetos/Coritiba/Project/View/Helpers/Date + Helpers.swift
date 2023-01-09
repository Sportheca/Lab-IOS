//
//  Date + Helpers.swift
//
//
//  Created by Roberto Oliveira on 03/11/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import Foundation

extension DateFormatter {
    func applyDefaultConfig() {
        //self.locale = .current
        self.locale = Locale.init(identifier: "pt-br")
        self.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    }
}

extension Date {
    
    static func nowDescription() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.applyDefaultConfig()
        return formatter.string(from: Date())
    }
    
    static func now() -> Date {
        return Date.dateFrom(string: Date.nowDescription(), format: "yyyy-MM-dd HH:mm:ss") ?? Date()
    }

    static func dateFrom(string:String, format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.applyDefaultConfig()
        return formatter.date(from: string)
    }
    
    
    func stringWith(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.applyDefaultConfig()
        let stringWith = formatter.string(from: self)
        return stringWith
    }
    
    func monthDescription(short:Bool) -> String {
        let key = self.stringWith(format: "MM")
        switch key {
        case "01": return short ? "Jan" : "Janeiro"
        case "02": return short ? "Fev" : "Fevereiro"
        case "03": return short ? "Mar" : "Março"
        case "04": return short ? "Abr" : "Abril"
        case "05": return short ? "Mai" : "Maio"
        case "06": return short ? "Jun" : "Junho"
        case "07": return short ? "Jul" : "Julho"
        case "08": return short ? "Ago" : "Agosto"
        case "09": return short ? "Set" : "Setembro"
        case "10": return short ? "Out" : "Outubro"
        case "11": return short ? "Nov" : "Novembro"
        case "12": return short ? "Dez" : "Dezembro"
        default: return ""
        }
    }
    
    func timeAgoDescription() -> String {
        let secondsAgo = Int(Date.now().timeIntervalSince(self))
        
        // Helper Units
        let minute = 60
        let hour = minute * 60
        let day = hour * 24
        let week = day * 7
        
        // Less than 60 seconds
        if secondsAgo < minute {
            return (secondsAgo > 1) ? String(format: "há %d segundos", secondsAgo) : "há 1 segundo"
        // Less than 60 minutes
        } else if secondsAgo < hour {
            let minutesAgo = secondsAgo/minute
            return (minutesAgo > 1) ? String(format: "há %d minutos", minutesAgo) : "há 1 minuto"
        // Less than 24 hours
        } else if secondsAgo < day {
            let hoursAgo = secondsAgo/hour
            return (hoursAgo > 1) ? String(format: "há %d horas", hoursAgo) : "há 1 hora"
        // Less than a week
        } else if secondsAgo < week {
            let daysAgo = secondsAgo/day
            return (daysAgo > 1) ? String(format: "há %d dias", daysAgo) : "há 1 dia"
        // Less than a month
        }
        
        let dateString = self.stringWith(format: "dd/MM/yyyy - HH:mm")
        if dateString.hasSuffix("00:00") {
            return dateString.substringUpTo(char: " ", at: .first, charIncluded: false)
        }
        return dateString
        
    }
    
}

