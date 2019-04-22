//
//  OrderService.swift
//  PurifyIt
//
//  Created by Waqas Ahmad on 08/04/2019.
//  Copyright © 2019 Waqas Ahmad. All rights reserved.
//

import Foundation
class OrderService : BaseService{
    //MARK:- Place Order
    func placeOrder(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL // + URL_ORDER
        let params = ["date":requestMessage.date1,
                      "subscription":requestMessage.subscription,
                      "slot_id":requestMessage.slotId,
                      "frequency":requestMessage.frequency,
                      "user_id":requestMessage.id,
                      "service_id":requestMessage.serviceId,
                      "time":requestMessage.time,
                      "rooms":requestMessage.numRoom,
                      "order_have":requestMessage.things,
                      "order_key":requestMessage.keys,
                      "order_paslock":requestMessage.pincode,
                      "amount":requestMessage.amount,
                      "image_id":requestMessage.imageKey,
                      "additional_services":requestMessage.additionalServices,
                      //"status":requestMessage.status,
                    "additional_services_quantity":requestMessage.AdditionServiceQuantity,
                    "window_side":requestMessage.windowSides,
                    "window_name":requestMessage.windowType,
                    "no_of_window":requestMessage.NumberOfWindows
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
//                        let list = PlaceOrderViewModel(data: data["data"])
//                        serviceResponse.data = list
                        //print(klist)
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
    
    //MARK:- Get Orders Api
    func getOrders(requestMessage: RequestMessage, complete: @escaping ((_ responseMessage: ServiceResponseMessage)->Void)){
        
        let homeURL = BASE_URL //+ URL_GET_ORDERS
        let params = ["user_id":requestMessage.id]
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
//                        let list = OrderListViewModel(order: data)
//                        serviceResponse.data = list
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
