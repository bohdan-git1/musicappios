//
//  LoginViewModel.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 19/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

enum LoginKeys: String{
    case createdAt = "created_at"
    case email     = "email"
    case id        = "id"
    case image     = "image"
    case mobileNo  = "mobile_no"
    case name      = "name"
    case status    = "status"
    case updatedAt = "updated_at"
}

class LoginViewModel : NSObject,NSCoding{
    
    var createdAt  : String
    var email      : String
    var id         : Int
    var image      : String
    var mobileNo   : String
    var name       : String
    var status     : Int
    var updatedAt  : String
    
    override init() {
       self.createdAt  = ""
       self.email      = ""
       self.id         = 0
       self.image      = ""
       self.mobileNo   = ""
       self.name       = ""
       self.status     = 0
       self.updatedAt  = ""
    }
    
    convenience init(model:JSON){
        self.init()
       self.createdAt = model[LoginKeys.createdAt.rawValue].string ?? ""
       self.email = model[LoginKeys.email.rawValue].string ?? ""
       self.id = model[LoginKeys.id.rawValue].int ?? 0
       self.image = model[LoginKeys.image.rawValue].string ?? ""
       self.mobileNo = model[LoginKeys.mobileNo.rawValue].string ?? ""
       self.name = model[LoginKeys.name.rawValue].string ?? ""
       self.status = model[LoginKeys.status.rawValue].int ?? 0
       self.updatedAt = model[LoginKeys.updatedAt.rawValue].string ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(self.id), forKey: "id")//(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.mobileNo, forKey: "mobileNo")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.image, forKey: "image")
        
    }
    
    required init?(coder aDecoder : NSCoder) {
        self.name   = aDecoder .decodeObject(forKey: "name") as? String ?? ""
        self.email = aDecoder .decodeObject(forKey: "email") as? String ?? ""
        self.mobileNo = aDecoder .decodeObject(forKey: "mobileNo") as? String ?? ""
        self.id = Int(aDecoder .decodeCInt(forKey: "id") as? Int32 ?? 0)
        self.updatedAt = aDecoder .decodeObject(forKey: "updatedAt") as? String ?? ""
        self.createdAt = aDecoder .decodeObject(forKey: "createdAt") as? String ?? ""
        self.image = aDecoder .decodeObject(forKey: "image") as? String ?? ""
        self.status = aDecoder .decodeObject(forKey: "status") as? Int ?? 0
    }
}
