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

class LoginViewModel{
    
    var createdAt  : String
    var email      : String
    var id         : Int
    var image      : String
    var mobileNo   : String
    var name       : String
    var status     : Int
    var updatedAt  : String
    
    init() {
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
}
