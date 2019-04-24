//
//  MenuViewController.swift
//  Nafees
//
//  Created by Waqas Ahmad on 04/12/2018.
//  Copyright © 2018 Waqas Ahmad. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // @IBOutlet weak var menu : UIButton?
    @IBOutlet weak var sideMenuTableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sideMenuTableView?.reloadData()
    }
    
    //MARK:- Functions
    
}
//MARK:- TABLE VIEW DELEGATE AND DATASOURCE
extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return Menu.MENU_LIST.count+1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 185
        }
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SideMenuProfileTableViewCell, for: indexPath) as? SideMenuProfileTableViewCell
            cell?.configure()
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SideMenuTableViewCell, for: indexPath) as? SideMenuTableViewCell
            cell?.configure(image: Menu.MENU_LIST[indexPath.row-1]["image"]!, title: Menu.MENU_LIST[indexPath.row-1]["title"]!)
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let container = self.revealViewController().frontViewController as? MainContainerViewController{
            print("container exist \(container)")
            self.revealViewController().revealToggle(nil)
        
            if(indexPath.row == 0){
                container.showProfileController()
            }
            
            if(indexPath.row == 1){
                container.showHomeController()
            }
            if(indexPath.row == 2){
                container.showSongList()
            }
            if(indexPath.row == 3){
               container.signOut()
            }
            
            
        }
        
    }
    
    
}

