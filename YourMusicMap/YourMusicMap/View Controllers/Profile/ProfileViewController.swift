//
//  ProfileViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 19/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController,TopBarDelegate {
    
    
    @IBOutlet weak var imgProfile  : UIImageView!
    @IBOutlet weak var btnAddImage : UIButton!
    @IBOutlet weak var txtEmail    : UITextField!
    @IBOutlet weak var txtName     : UITextField!
    @IBOutlet weak var txtPhone    : UITextField!
    @IBOutlet weak var viewEmail   : UIView!
    @IBOutlet weak var viewPhone   : UIView!
    @IBOutlet weak var viewName    : UIView!
    
    var allowEditing : Bool = false
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       self.configure()
       // self.btnAddImage.addGestureRecognizer(tapGestureRecognizer)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.topBarHeight.constant = TOP_BAR_HEIGHT
            container.lblTitle.text = "Profile"
            container.delegate = self
            container.btnMenu.isHidden = true
            container.btnBack.isHidden = false
            container.btnEdit.isHidden = false
        }
    }
    func configure(){
        self.txtPhone.text = Global.shared.login.mobileNo
        self.txtEmail.text = Global.shared.login.email
        self.txtName.text  = Global.shared.login.name
        self.setImageWithUrl(imageView: self.imgProfile, url: Global.shared.login.image,profile: "dpRound")
        self.viewName.layer.cornerRadius = 5
        self.viewPhone.layer.cornerRadius = 5
        self.viewEmail.layer.cornerRadius = 5
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        // self.imgProfile!.isUserInteractionEnabled = true
        self.txtPhone.isUserInteractionEnabled = false
        self.txtName.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.imgProfile.isUserInteractionEnabled = false
        self.imgProfile!.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func actionCallBackMoveBack() {
        if let container = self.mainContainer{
            container.showHomeController()
        }
    }
    func actionCallBackEdit(){
        if(self.allowEditing){
            if let container = self.mainContainer{
                container.btnEdit.setTitle("Edit", for: .normal)
                self.txtPhone.isUserInteractionEnabled = false
                self.txtName.isUserInteractionEnabled = false
                self.txtEmail.isUserInteractionEnabled = false
                self.imgProfile.isUserInteractionEnabled = false
                self.allowEditing = false
            }
            
        }else{
            if let container = self.mainContainer{
                container.btnEdit.setTitle("Save", for: .normal)
                self.txtPhone.isUserInteractionEnabled = true
                self.txtName.isUserInteractionEnabled = true
                self.txtEmail.isUserInteractionEnabled = true
                self.imgProfile.isUserInteractionEnabled = true
                self.allowEditing = true
            }
            
            }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
       let storyboard = UIStoryboard(name: StoryboardName.Registration, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UploadImageViewController) as? UploadImageViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    //MARK:- Actions
    
    @IBAction func actionUpdate(_ sender:Any){
        if(self.allowEditing){
            if let container = self.mainContainer{
                container.btnEdit.setTitle("Edit", for: .normal)
            }
        }
    }

}

extension ProfileViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
