//
//  SongTableViewCell.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 23/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class SongTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lblSongTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(song:SongViewModel){
        self.lblSongTitle.text = song.title
    }
}
