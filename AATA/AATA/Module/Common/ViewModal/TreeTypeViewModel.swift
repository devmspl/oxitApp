//
//  TreeTypeViewModel.swift
//  AATA
//
//  Created by M1 on 25/03/22.
//

import UIKit

class TreeTypeViewModel: NSObject {

    func treeType(_ completion: @escaping(TreeData?, Bool) -> Void) {
        APIServices.shared.treeType { response, isSuccess in
            completion(response , isSuccess)

        }
    }
    
    
    
    func getGateway(propertyID : String,_ completion: @escaping(GatewayData?, Bool) -> Void) {
        APIServices.shared.getGatewayInformation(propertyId: propertyID, { response, isSuccess in
            completion(response, isSuccess)
        })
    }
    
}
