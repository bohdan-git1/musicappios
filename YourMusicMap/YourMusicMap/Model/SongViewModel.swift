//
//  SongViewModel.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 23/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON
class SongViewModel{
    var createdAt : String
    var id        : Int
    var lat       : String
    var lng       : String
    var path      : String
    var status    : Int
    var title     : String
    var updatedAt : String
    var userId    : Int
    var amount    : Double
    
    init() {
        self.createdAt = ""
        self.id        = 0
        self.lat       = ""
        self.lng       = ""
        self.path      = ""
        self.status    = 0
        self.title     = ""
        self.updatedAt = ""
        self.userId    = 0
        self.amount    = 0
        
    }
    
    convenience init(song:JSON){
        self.init()
        self.createdAt = song["created_at"].string ?? ""
        self.id = song["id"].int ?? 0
        self.lat = song["lat"].string ?? ""
        self.lng = song["lng"].string ?? ""
        self.path = song["path"].string ?? ""
        self.status = song["status"].int ?? 0
        self.title = song["title"].string ?? ""
        self.updatedAt = song["updated_at"].string ?? ""
        self.userId = song["user_id"].int ?? 0
        self.amount = song["amount"].double ?? 0.0
    }
}
