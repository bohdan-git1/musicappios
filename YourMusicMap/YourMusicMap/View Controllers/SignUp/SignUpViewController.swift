//
//  SignUpViewController.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 18/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var txtName     : UITextField!
    @IBOutlet weak var txtEmail    : UITextField!
    @IBOutlet weak var txtPhone    : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnSubmit   : UIButton!
    @IBOutlet weak var btnFacebook : UIButton!
    @IBOutlet weak var btnGoogle   : UIButton!
    
    var isLogin = false
    var image : String?
    var loginViewModel : LoginViewModel?
    
    let loginManager: LoginManager = LoginManager()
    
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
        Global.shared.isFbLogin = true
        self.doLoginWithFacebook()
    }
    @IBAction func actionGooglePlus(_ sender:Any){
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        Global.shared.isFbLogin = false
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
}
extension SignUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController:GIDSignInDelegate,GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        GCD.async(.Main) {
            self.stopActivity()
        }
        if let error = error {
            print("\(error.localizedDescription)")
            showAlertVIew(message: AlertViewTitle.FaliedSocialLogin, title: AlertViewTitle.Google)
        } else {
            self.txtName.text = user.profile.name
            self.txtEmail.text = user.profile.email
            self.image = user.profile.imageURL(withDimension: 500)?.absoluteString ?? ""
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        GCD.async(.Main) {
            self.stopActivity()
        }
    }
    func doLoginWithFacebook()  {
        GCD.async(.Main, execute: {
            self.startActivityWithMessage(msg: "")
        })
        self.loginManager.logOut()
        Global.shared.isFbLogin = true
        self.loginManager.loginBehavior = .browser
        self.loginManager.logIn(readPermissions: [ .publicProfile, .email, .userFriends], viewController: self) { (loginResult) in
            
            GCD.async(.Main, execute: {
                self.stopActivity()
            })
            switch loginResult
            {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken)
                print("Logged in!")
                self.fetchFacebookProfileInfo(token: accessToken)
                
            }
        }
        
        
        
    }
    func fetchFacebookProfileInfo(token:AccessToken) {
        
        GCD.async(.Main, execute: {
            self.startActivityWithMessage(msg: "")
        })
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "me", parameters: SocialLogin.FacebookProfileParams))
        {
            httpResponse, result in
            GCD.async(.Main, execute: {
                self.stopActivity()
            })
            switch result {
            case .failed(let error):
                print("Graph Request Failed: \(error)")
                
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                if let res = response.dictionaryValue{
                    if let fName = res["first_name"] as? String{
                        self.txtName.text = fName
                    }
                    if let lName = res["last_name"] as? String{
                        self.txtName.text = "\(self.txtName.text!) \(lName)"
                    }
                    if let email = res["email"] as? String{
                        self.txtEmail.text = email
                    }
                    if let picture = res["picture"] as? [String:Any]{
                        if let data = picture["data"] as? [String:Any]{
                            if let url = data["url"] as? String{
                                self.image = url
                            }
                        }
                        
                    }
                    
                }
            }
        }
        connection.start()
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
                            let data = NSKeyedArchiver.archivedData(withRootObject: login)
                            UserDefaults.standard.set(data, forKey: LOGIN_KEY)
                            UserDefaults.standard.synchronize()
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
