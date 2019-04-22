//
//  MainContainerViewController.swift
//  CabIOS
//
//  Created by Ghafar Tanveer on 06/02/2018.
//  Copyright © 2018 Ghafar Tanveer. All rights reserved.
//

import UIKit

protocol TopBarDelegate:NSObjectProtocol {
    func actionCallBackMoveBack()
    func actionCallBackEdit()
}

class MainContainerViewController: BaseViewController {
    
   
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenu : UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnEdit:UIButton!
    
    
    var delegate:TopBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenu(button: btnMenu)
        self.setBorderColor(view: self.btnEdit, color: UIColor.gray, width: 1)
        self.btnEdit.layer.cornerRadius = 5
        self.showHomeController()
        
    }
  

    //MARK:- FUNCTIONS
    func showHomeController()  {
        let storyBoard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.HomeNavigationController) as! BaseNavigationController
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showProfileController()  {
        let storyBoard = UIStoryboard(name: StoryboardName.Registration, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.ProfileNavigationController) as! BaseNavigationController
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
 

    

    
    
    //MARK:- ACTION METHODS
    @IBAction func actionBack(_ sender: UIButton){
        if let del = self.delegate{
            del.actionCallBackMoveBack()
        }
    }
    @IBAction func actionEdit(_ sender:UIButton){
        if let del = self.delegate{
            del.actionCallBackEdit()
        }
    }
    
   
    
}
