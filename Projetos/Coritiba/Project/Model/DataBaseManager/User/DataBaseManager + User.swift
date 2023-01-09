//
//  DataBaseManager + User.swift
//
//
//  Created by Roberto Oliveira on 28/03/19.
//  Copyright © 2019 SportsMatch. All rights reserved.
//

import Foundation
import SQLite3

extension DataBaseManager {
    
    func user(for id:String) -> User? {
        guard id != "" else {return nil}
        // Open Database
        self.openDatabase()
        self.createTableIfNeeded(query: User.CREATE_USERS_TABLE)
        
        // Select Data
        var stmt:OpaquePointer?
        if sqlite3_prepare_v2(self.database, "SELECT id, name, email, img, cpf, phone, terms, born, coins, token, gender, badges, ismember, membertoken, signupat, membercardid FROM users WHERE id = '\(id)'", -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Error preparing SELECT: \(errorMessage)")
        }
        var item:User?
        while sqlite3_step(stmt) == SQLITE_ROW {
            //let id = Int(sqlite3_column_int64(stmt, 0))
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let user = User(id: id)
            
            user.name = String(cString: sqlite3_column_text(stmt, 1))
            user.email = String(cString: sqlite3_column_text(stmt, 2))
            user.imageUrl = String(cString: sqlite3_column_text(stmt, 3))
            user.cpf = String(cString: sqlite3_column_text(stmt, 4))
            user.phone = String(cString: sqlite3_column_text(stmt, 5))
            
            let termsVersion:Float = Float.floatValue(from: String(cString: sqlite3_column_text(stmt, 6))) ?? 1.0
            user.termsVersion = termsVersion
            
            let dateString = String(cString: sqlite3_column_text(stmt, 7))
            let bornDate = Date.dateFrom(string:dateString, format: "yyyy-MM-dd")
            user.born = bornDate
            
            user.coins = Int(sqlite3_column_int64(stmt, 8))
            user.token = String(cString: sqlite3_column_text(stmt, 9))
            
            let gender:Gender = Gender(rawValue: Int(sqlite3_column_int64(stmt, 10))) ?? Gender.NotDefined
            user.gender = gender
            
            user.badges = Int(sqlite3_column_int64(stmt, 11))
            
            let memberShipMode:MembershipMode = MembershipMode(rawValue: Int(sqlite3_column_int64(stmt, 12))) ?? MembershipMode.None
            user.membershipMode = memberShipMode
            user.membershipToken = String(cString: sqlite3_column_text(stmt, 13))
            
            let signupAtString = String(cString: sqlite3_column_text(stmt, 14))
            let signupAtDate = Date.dateFrom(string: signupAtString, format: "yyyy-MM-dd")
            user.signupAt = signupAtDate
            
            user.membershipCardID = Int(sqlite3_column_int64(stmt, 15))
            
            item = user
        }
        
        // Finalize Statement
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Error finalizing prepared statement: \(errorMessage)")
        }
        stmt = nil
        
        // Close Database
        self.closeDatabase()
        
        return item
    }
    
    
    
    func set(user:User) {
        // Open Database
        self.openDatabase()
        self.createTableIfNeeded(query: User.CREATE_USERS_TABLE)
        
        // Insert Data
        self.performQuery(string: "DELETE FROM users WHERE id='\(user.id)' LIMIT 1")
        
        let id:String = user.id
        let name:String = user.name ?? ""
        let email:String = user.email ?? ""
        let imageUrl:String = user.imageUrl ?? ""
        let cpf:String = user.cpf ?? ""
        let phone:String = user.phone ?? ""
        let termsVersion:Float = user.termsVersion
        let born:String = user.born?.stringWith(format:"yyyy-MM-dd") ?? ""
        let gender:Int = user.gender?.rawValue ?? 0
        let coins:Int = user.coins ?? 0
        let token:String = user.token ?? ""
        let badges:Int = user.badges ?? 0
        let ismember:Int = user.membershipMode.rawValue
        let memberToken:String = user.membershipToken
        let memberCardID:Int = user.membershipCardID
        let signupAt:String = user.signupAt?.stringWith(format:"yyyy-MM-dd") ?? ""
        
        let queryString = "INSERT INTO users (id, name, email, img, cpf, phone, terms, born, coins, token, gender, badges, ismember, membertoken, signupat, membercardid) VALUES ('\(id)', '\(name)', '\(email)', '\(imageUrl)', '\(cpf)', '\(phone)', '\(termsVersion)', '\(born)', \(coins), '\(token)', \(gender), \(badges), \(ismember), '\(memberToken)', '\(signupAt)', \(memberCardID))"
        
        self.performQuery(string: queryString)
        
        // Close Database
        self.closeDatabase()
    }
    
}
