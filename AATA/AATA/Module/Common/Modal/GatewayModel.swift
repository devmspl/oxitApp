//
//  GatewayModel.swift
//  AATA
//
//  Created by M1 on 25/03/22.
//

import UIKit
import SwiftyJSON


class GatewayData : NSObject{
    var records : [GatewayModel]?
}

extension GatewayData{
    convenience init(_ data: JSON){
        self.init()
        if let recordArr = data["records"].array{
            for i in recordArr{
                records = recordArr.map({return GatewayModel($0)})
            }
        }
    }
}

class GatewayModel: NSObject {

    var deviceId : String = ""
    var id: Int = 0
    
    
}

extension GatewayModel{
    convenience init(_ data: JSON){
        self.init()
        deviceId = data["deviceId"].stringValue
        id = data["id"].intValue
    }
}
