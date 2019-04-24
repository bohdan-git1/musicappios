//
//  ImageService.swift
//  PurifyIt
//
//  Created by Waqas Ahmad on 03/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
class ImageService : BaseService{
    
    
    //MARK:- Image Upload Api
    func uploadImage(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL + URL_UPLOAD_IMAGE
        
        let params = [
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
                        
//                        let list = ImageViewModel(image: data["data"])
//                        serviceResponse.data = list
//                        print(list)
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
    
    //MARK:- Delete Image Api
    func deleteImage(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL //+ URL_DELETE_IMAGE
        
        let params = [
            "image_id":requestMessage.id,
            ] as [String : Any]
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
}
