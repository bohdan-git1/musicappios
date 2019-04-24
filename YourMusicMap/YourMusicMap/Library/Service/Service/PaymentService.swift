//
//  PaymentService.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 24/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
class PaymentService : BaseService{
    //MARK:- Get Songs Api
    func getCleintAccessToken(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL  + URL_GENERATE_TOKEN
        let params = ["":""]
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
                        let key = data["data"].string ?? ""
                        Global.shared.clientToken = key
                        
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


