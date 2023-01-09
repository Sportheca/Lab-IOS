//
//  User.swift
//
//
//  Created by Roberto Oliveira on 19/10/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

enum Gender:Int {
    case NotDefined = 0
    case Female = 1
    case Male = 2
    case Other = 3
    
    func genderDescription() -> String? {
        switch self {
        case .NotDefined: return nil
        case .Female: return "Feminino"
        case .Male: return "Masculino"
        case .Other: return "Outro"
        }
    }
}

enum MembershipMode:Int {
    case None = 0
    case Active = 1
    
    func isBenefitsActive() -> Bool {
        switch self {
        case .None: return false
        case .Active: return true
        }
    }
    
    func title() -> String? {
        switch self {
        case .None: return nil
        case .Active: return "Ativo"
        }
    }
    
}

class User {
    
    static let CREATE_USERS_TABLE:String = "CREATE TABLE IF NOT EXISTS users (id TEXT, name TEXT, email TEXT, img TEXT, cpf TEXT, phone TEXT, terms TEXT, born TEXT, coins INTEGER, token TEXT, gender INTEGER, badges INTEGER, ismember INTEGER, membertoken TEXT, signupat TEXT, membercardid INTEGER)"
    
    // MARK: - Properties
    var id:String = ""
    var name:String?
    var email:String?
    var imageUrl:String?
    
    var cpf:String?
    var phone:String?
    var termsVersion:Float = 0
    var born:Date?
    var gender:Gender?
    var signupAt:Date?
    var token:String?
    
    var coins:Int?
    var badges:Int?
    
    var membershipMode:MembershipMode = MembershipMode.None
    var membershipToken:String = ""
    var membershipCardID:Int = 0
    
    func membershipTitle() -> String {
        return self.membershipMode != .None ? "Sócio Torcedor" : "Torcedor"
    }
    
    func isMembershipCardIDCompleted() -> Bool {
        let name = self.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phone = self.phone?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = self.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if name.isEmpty || phone.isEmpty || email.isEmpty {
            return false
        }
        return true
    }
    
    
    // MARK: - Methods
    func save() {
        DataBaseManager.shared.set(user:self)
    }
    
    
    // MARK: - Init Methods
    init(id: String) {
        self.id = id
    }
    
}

