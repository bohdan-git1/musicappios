//
//  SongListViewModel.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 23/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

class SongListViewModel{
    
    var songList : [SongViewModel]
    
    init() {
        self.songList = [SongViewModel]()
    }
    
    convenience init(songList:JSON){
        self.init()
        if let list = songList["data"].array{
            for eachSong in list{
                self.songList.append(SongViewModel(song: eachSong))
            }
        }
    }
}
