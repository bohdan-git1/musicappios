//
//  SideMenuTableViewCell.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imgRow : UIImageView!
    @IBOutlet weak var lblRow : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(image:String,title:String){
        self.imgRow.image = UIImage(named: image)
        self.lblRow.text = title
    }

}
