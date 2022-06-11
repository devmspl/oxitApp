//
//  EndDevice.swift
//  NPI
//
//  Created by Uday Patel on 09/10/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit
import SwiftyJSON

///
class EndDevice: NSObject {
    ///
    var id: String = ""
    ///
    var clientId: Int = 0
    ///
    var propertyid: Int = 0
    ///
    var name: String = ""
    ///
    var status: String = ""
    ///
    var deviceId: String = ""
    ///
    var deviceState: String = ""
    ///
    var endDeviceType: String = ""
    ///
    var lastCheckIn: String = ""
    ///
    var trackingNumber: String = ""
    ///
    var clientInfo: ClientInfo?
    ///
    var propertyInfo: PropertyInfo?
    ///
    var alarmSiren: AlarmSiren?
    ///
    var treeTiltSensor: TreeTiltSensor?
    
}

///
extension EndDevice {
    ///
    convenience init(_ data: JSON) {
        self.init()
        id = data["id"].stringValue
        propertyid = data["propertyid"].intValue
        name = data["name"].stringValue
        status = data["status"].stringValue
        deviceId = data["deviceId"].stringValue
        deviceState = data["deviceState"].stringValue
        endDeviceType = data["endDeviceType"].stringValue
        lastCheckIn = data["lastCheckIn"].stringValue
        trackingNumber = data["trackingNumber"].stringValue
        clientId = data["clientId"].intValue
        clientInfo = ClientInfo.init(data["Client"])
        propertyInfo = PropertyInfo.init(data["Property"])
        alarmSiren = AlarmSiren.init(data["alarmSiren"])
        treeTiltSensor = TreeTiltSensor.init(data["treeTiltSensor"])
    }
}

///
class PropertyInfo: NSObject {
    ///
    var id: String = ""
    ///
    var name: String = ""
    ///
    var type: String = ""
    ///
    var locationName: String = ""
    ///
    var locationNumber: String = ""
    ///
    var addressLine1 : String = ""
    ///
    var city : String = ""
    ///
    var state : String = ""
    
}

///
extension PropertyInfo {
    ///
    convenience init(_ data: JSON) {
        self.init()
        id = data["id"].stringValue
        name = data["name"].stringValue
        type = data["type"].stringValue
        locationName = data["locationName"].stringValue
        locationNumber = data["locationNumber"].stringValue
        addressLine1 = data["addressLine1"].stringValue
        city = data["city"].stringValue
        state = data["state"].stringValue
    }
}

///
class ClientInfo: NSObject {
    ///
    var id: String = ""
    ///
    var companyName: String = ""
    ///
    var projectName: String = ""
}

///
extension ClientInfo {
    ///
    convenience init(_ data: JSON) {
        self.init()
        id = data["id"].stringValue
        companyName = data["companyName"].stringValue
        projectName = data["projectName"].stringValue
    }
}
