//
//  EndDeviceIdViewModel.swift
//  AATA
//
//  Created by M1 on 29/03/22.
//

import UIKit

class EndDeviceIdViewModel: NSObject {

    func getDeviceId(propertyId: String,endDeviceType: String,gatewayId: String,clientId: String, completion: @escaping([String:Any],Bool)->()){
        let queryString = "count=\(25)" + "&offset=\(0)" + "&propertyId=\(propertyId)"+"&endDeviceType=\(endDeviceType)"+"&gatewayId=\(gatewayId)"+"&clientId=\(clientId)"
        APIServices.shared.getEndDeveiceIdApi(queryString) { datalist, isSuccess in
            if isSuccess{
                completion(datalist,true)
            }else{
                
            }
        }
    }
    
}
