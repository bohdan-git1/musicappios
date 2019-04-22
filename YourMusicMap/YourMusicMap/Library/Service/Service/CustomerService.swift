//
//  CustomerService.swift
//  Nafees
//
//  Created by Waqas Ahmad on 25/01/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation

class CustomerService: BaseService {
    
    
    //MARK:- SignUp
    
    func registerNewUser(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL + URL_Signup
        
        let params = ["name":requestMessage.name,
                      "username":requestMessage.email,
                      "password":requestMessage.password,
                      "mobile_no":requestMessage.phone                                            ] as [String : Any]
        print(params)
        
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
                
            case .Success:
                
                let parsedResponse = ResponseHandler.handleResponseStructure(networkResponseMessage: networkResponseMessage)
                switch parsedResponse.serviceResponseType{
                    
                case .Success:
                    
                    if let data = parsedResponse.swiftyJsonData  {
                        
                        let serviceResponse = self.getSuccessResponseMessage(parsedResponse.message)
                        
                        let list = LoginViewModel(model: data["data"])
                        serviceResponse.data = list
                        print(list)
                        complete(serviceResponse)
                    }
                    else{
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        complete(response)
                    }
                    
                default:
                    let response = self.getDefaultServiceResponse(parsedResponse)
                    complete(response)
                    
                }
            case .Failure:
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout:
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
        
    }
    
    
    //MARK:- Update User
    
    func updateUserProfile(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL //+ URL_UPDATE_PROFILE
        
        let params = ["first_name":requestMessage.firstName,
                      "last_name":requestMessage.lastName,
                      "email":requestMessage.email,
                     // "password":requestMessage.password,
                      "phone_number":requestMessage.phone,
                      "street" :requestMessage.street,
                      "zip": requestMessage.zip,
                      "city" : requestMessage.city,
                      "status" : requestMessage.status,
                      "area" : requestMessage.area,
                      "no_rooms":requestMessage.numRoom,
//                      "rooms_type":requestMessage.roomType,
                      "crn":requestMessage.crn,
                      "imageKey":requestMessage.imageKey,
                      "image":requestMessage.image,
                      "id" : requestMessage.id] as [String : Any]
        
        print(params)
        
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performUploadImageNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
                
            case .Success:
                
                let parsedResponse = ResponseHandler.handleResponseStructure(networkResponseMessage: networkResponseMessage)
                switch parsedResponse.serviceResponseType{
                    
                case .Success:
                    
                    if let data = parsedResponse.swiftyJsonData  {
                        
                        let serviceResponse = self.getSuccessResponseMessage(parsedResponse.message)
                        
                        let list = LoginViewModel(model: data["data"])
                        serviceResponse.data = list
                        print(list)
                        complete(serviceResponse)
                    }
                    else{
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        complete(response)
                    }
                    
                default:
                    let response = self.getDefaultServiceResponse(parsedResponse)
                    complete(response)
                    
                }
            case .Failure:
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout:
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
        
    }
    
    
    
    //MARK:- ForgetPassword
    
    func forgetPassword(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL //+ URL_FORGET_PASSWORD
        
        let params = [
                      "email":requestMessage.email,
                      ]
        print(params)
        
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
                
            case .Success:
                
                let parsedResponse = ResponseHandler.handleResponseStructure(networkResponseMessage: networkResponseMessage)
                switch parsedResponse.serviceResponseType{
                    
                case .Success:
                     if let data = parsedResponse.swiftyJsonData  {
                         let serviceResponse = self.getSuccessResponseMessage(parsedResponse.message)
                         let message = data["message"].string
                        serviceResponse.message = message!
                        complete(serviceResponse)
                    }
                    else{
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        complete(response)
                    }
                    
                default:
                    let response = self.getDefaultServiceResponse(parsedResponse)
                    complete(response)
                    
                }
            case .Failure:
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout:
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
        
    }
    
    //MARK:- change Password
      func changePassword(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL //+ URL_CHANGE_PASSWORD
        
        let params = [
            "user_id":requestMessage.id,
            "old_password" : requestMessage.password,
            "new_password" : requestMessage.confirmPassword
            ]
        print(params)
        
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
                
            case .Success:
                
                let parsedResponse = ResponseHandler.handleResponseStructure(networkResponseMessage: networkResponseMessage)
                switch parsedResponse.serviceResponseType{
                    
                case .Success:
                    if let data = parsedResponse.swiftyJsonData  {
                        let serviceResponse = self.getSuccessResponseMessage(parsedResponse.message)
                        let message = data["message"].string
                        serviceResponse.message = message!
                        complete(serviceResponse)
                    }
                    else{
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        complete(response)
                    }
                    
                default:
                    let response = self.getDefaultServiceResponse(parsedResponse)
                    complete(response)
                    
                }
            case .Failure:
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout:
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
        
    }
    
    
    //MARK:- SignIn
    
    func doLogin(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL + URL_LOGIN
        
        let params = ["username":requestMessage.email,
                      "password":requestMessage.password,
                      ]
        print(params)
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
            switch networkResponseMessage.statusCode {
                
            case .Success:
                
                let parsedResponse = ResponseHandler.handleResponseStructure(networkResponseMessage: networkResponseMessage)
                switch parsedResponse.serviceResponseType{
                    
                case .Success:
                    
                    if let data = parsedResponse.swiftyJsonData  {
                        
                        let serviceResponse = self.getSuccessResponseMessage(parsedResponse.message)

                        let list = LoginViewModel(model: data["data"])
                        serviceResponse.data = list
                        print(list)
                        complete(serviceResponse)
                     }
                    else{
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        complete(response)
                    }
                    
                default:
                    let response = self.getDefaultServiceResponse(parsedResponse)
                    complete(response)
                    
                }
            case .Failure:
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout:
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
        
    }
}
