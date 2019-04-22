//
//  SignUpViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var txtName     : UITextField!
    @IBOutlet weak var txtEmail    : UITextField!
    @IBOutlet weak var txtPhone    : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnSubmit   : UIButton!
    @IBOutlet weak var btnFacebook : UIButton!
    @IBOutlet weak var btnGoogle   : UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addToolBarToPickerView(textField: self.txtPhone)
        self.btnFacebook.layer.cornerRadius = 10
        self.btnGoogle.layer.cornerRadius = 10
        self.btnSubmit.layer.cornerRadius = 5
        self.btnSubmit.layer.borderColor = AppColors.darkBlue.cgColor
        self.btnSubmit.layer.borderWidth = 1
    }
    
    func checkValidation() -> Bool {
        var message = ""
        var isValid = true
        if(self.txtPhone!.text!.isEmpty || self.txtName!.text!.isEmpty || self.txtEmail!.text!.isEmpty || self.txtPassword!.text!.isEmpty){
            message = Messages.Fill_All_Fields
            isValid = false
        }else if(!self.isValidEmail(testStr: self.txtEmail!.text!)){
            message = Messages.Valid_Email
            isValid = false
        }
        if(!isValid){
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return isValid
    }
    
    //MARK:- Actions
    
    @IBAction func actionBack(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender:Any){
        if(checkValidation()){
            self.registerAccount()
        }
    }
    
    @IBAction func actionFaceBookSignup(_ sender:Any){
        
    }
    @IBAction func actionGooglePlus(_ sender:Any){
        
        
    }
    @IBAction func actionLinkindin(_ sender:Any){
        
        
    }
}
extension SignUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK:- Signup Api
extension SignUpViewController{
    func registerAccount()  {
        let request:RequestMessage = self.createRegistrationRequst()
        GCD.async(.Default){
            GCD.async(.Main){
                self.startActivityWithMessage(msg: "")
            }
            let service = CustomerService()
            service.registerNewUser(requestMessage: request, complete: { (responseMessage) in
                GCD.async(.Main){
                    self.stopActivity()
                    switch responseMessage.serviceResponseType {
                    case .Success:
                        print(responseMessage)
                        if let login = responseMessage.data as? LoginViewModel{
                            
                            Global.shared.login = login
                            print(login.id)
                            
//                            let data = NSKeyedArchiver.archivedData(withRootObject: login)
//                            UserDefaults.standard.set(data, forKey: LOGIN_KEY)
//                            UserDefaults.standard.synchronize()
                            self.showHomeController()
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
    
    
    func showHomeController()  {
        let storyboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SWRevealViewController) as? SWRevealViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func createRegistrationRequst() -> RequestMessage {
        let request = RequestMessage()
        request.email = self.txtEmail!.text!
        request.password = self.txtPassword!.text!
        request.name = self.txtName!.text!
        request.phone = self.txtPhone!.text!
     
        return request
        
    }
    
}
