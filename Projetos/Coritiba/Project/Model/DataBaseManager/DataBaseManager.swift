//
//  DataBaseManager.swift
//
//
//  Created by Roberto Oliveira on 05/02/19.
//  Copyright © 2019 RobertoOliveira. All rights reserved.
//

import Foundation
import SQLite3

class DataBaseManager {
    
    // MARK: - Access Control
    private init() {}
    static let shared:DataBaseManager = DataBaseManager()
    
    
    
    // MARK: - Properties
    var database:OpaquePointer?
    
    
    
    
    // MARK: - Default Methods
    func debugError(string:String) {
        print("\nDataManager Error: ", string)
    }
    
    func openDatabase() {
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("banco.sqlite")
            if sqlite3_open(fileURL.path, &self.database) != SQLITE_OK {
                self.debugError(string: "Opening database failed.")
                return
            }
        } catch {
            self.debugError(string: "Documents Directory failed.")
        }
    }
    
    func closeDatabase() {
        if sqlite3_close(self.database) != SQLITE_OK {
            self.debugError(string: "Closing database failed.")
            return
        }
        self.database = nil
    }
    
    func createTableIfNeeded(query: String) {
        if sqlite3_exec(self.database, query, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Creating table failed: \(errorMessage)")
            return
        }
        return
    }
    
    func performQuery(string: String) {
        var stmt:OpaquePointer?
        // Prepare
        if sqlite3_prepare(self.database, string, -1, &stmt, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Binding query failed: \(errorMessage)")
            return
        }
        // Perform
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Failed to performQuery: \(errorMessage)")
            return
        }
        // Finalize statement
        if sqlite3_finalize(stmt) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            self.debugError(string: "Error finalizing prepared statement: \(errorMessage)")
            return
        }
        stmt = nil
    }
    
}
