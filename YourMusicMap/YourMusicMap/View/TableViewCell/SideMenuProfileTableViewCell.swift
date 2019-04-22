//
//  SideMenuProfileTableViewCell.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class SideMenuProfileTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(){
        self.lblEmail.text = Global.shared.login.email
        self.lblName.text  = Global.shared.login.name
        self.setImageWithUrl(imageView: self.imgProfile, url: Global.shared.login.image,profile: "dpRound")
    }
}
