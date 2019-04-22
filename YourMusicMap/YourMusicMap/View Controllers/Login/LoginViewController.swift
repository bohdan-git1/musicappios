//
//  LoginViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail    : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnLogin    : UIButton!
    @IBOutlet weak var btnHide     : UIButton!
    
    var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnLogin.layer.cornerRadius = 5
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = AppColors.darkBlue.cgColor
        // Do any additional setup after loading the view.
    }
    //MARK:- Functions
    
    func showHomeController() {
        let storyboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SWRevealViewController) as? SWRevealViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Actions
    @IBAction func actionLogin(_ sender:Any){
        if(self.txtPassword.text == "" || self.txtEmail.text == ""){
            self.showAlertVIew(message: "Please Fill all Fields", title: "Warning")
        }else{
            self.doLogin()
        }
    }
    
    @IBAction func actionRegister(_ sender:Any){
        let storyboard = UIStoryboard(name: StoryboardName.Registration, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SignUpViewController) as? SignUpViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func actionHidePassword(_ sender:Any){
        if(self.isHidden){
            self.btnHide.setImage(UIImage(named: "iconUnHide"), for: .normal)
            self.txtPassword.isSecureTextEntry = false
            self.isHidden = false
        }else{
            self.btnHide.setImage(UIImage(named: "iconHide"), for: .normal)
            self.txtPassword.isSecureTextEntry = true
            self.isHidden = true
        }
    }
    
    @IBAction func actionForgotPassword(_ sender:Any){
        
    }
}
extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK:- LOGIN API
extension LoginViewController{
    func doLogin()  {
        let request:RequestMessage = self.createRegistrationRequst()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = CustomerService()
            service.doLogin(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        if let login = responseMessage.data as? LoginViewModel{
                            Global.shared.login = login
                            print(login.id)
//                                let data = NSKeyedArchiver.archivedData(withRootObject: login)
//                                UserDefaults.standard.set(data, forKey: LOGIN_KEY)
//                                UserDefaults.standard.synchronize()
                                self.showHomeController()
                            }else{
                                self.showAlertVIew(message: "no user found", title: "")
                                
                            }
                        
                    case .Failure:
                        self.showAlertVIew(message: responseMessage.message, title: "")
                        
                    default:
                        print(responseMessage.message)
                        
                    }
                }
                
            })
        }
        
    }
    
    

    func createRegistrationRequst() -> RequestMessage {
        let request = RequestMessage()
        request.email = self.txtEmail!.text!
        request.password = self.txtPassword!.text!
        
        return request
        
    }
}
