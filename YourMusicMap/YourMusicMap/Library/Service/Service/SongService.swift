//
//  SongService.swift
//  YourMusicMap
//
//  Created by Waqas Ahmad on 22/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
class SongService : BaseService{
    //MARK:- Image Upload Api
    func uploadSong(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL + URL_UPLOAD_SONG
        
        let params = [
            "title":requestMessage.name,
            "audioPath":requestMessage.audioPath!,
            "audioKey":requestMessage.audioKey,
            "path":"",
            "user_id" : requestMessage.id,
            "lat":requestMessage.lat,
            "lng":requestMessage.long] as [String : Any]
        print(params)
        
        let networkRequestMessage = NetworkRequestMessage(requestType: .POST, contentType: .HTML, url: homeURL, params: params as Dictionary<String, AnyObject>)
        
        
        BaseNetwork().performUploadAudioNetworkTask(requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
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
}
