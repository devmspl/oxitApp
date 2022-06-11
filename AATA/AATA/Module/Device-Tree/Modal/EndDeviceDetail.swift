//
//  EndDeviceDetail.swift
//  AATA
//
//  Created by Uday Patel on 24/12/21.
//

import UIKit
import SwiftyJSON

///
class EndDeviceDetail: NSObject {
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
    var gatewayId: String = ""
    ///
    var lastCheckIn: String = ""
    ///
    var trackingNumber: String = ""
    ///
    var deviceDescription: String = ""
    ///
    var installationDate: String = ""
    ///
    var location: String = ""
    ///
    var updatedAt: String = ""
    ///
    var clientInfo: ClientInfo?
    ///
    var propertyInfo: PropertyInfo?
    ///
    var alarmSiren: AlarmSiren?
    ///
    var treeTiltSensor: TreeTiltSensor?
    ///
    var treeTiltSensorId : String?
    ///
    var installationDateServer : String?
}

///
extension EndDeviceDetail {
    ///
    convenience init(_ data: JSON) {
        self.init()
        id = data["id"].stringValue
        propertyid = data["propertyId"].intValue
        name = data["name"].stringValue
        status = data["status"].stringValue
        deviceId = data["deviceId"].stringValue
        deviceState = data["deviceState"].stringValue
        endDeviceType = data["endDeviceType"].stringValue
        gatewayId = data["gatewayId"].stringValue
        lastCheckIn = data["lastCheckin"].stringValue
        trackingNumber = data["trackingNumber"].stringValue
        clientId = data["clientId"].intValue
        clientInfo = ClientInfo.init(data["Client"])
        alarmSiren = AlarmSiren.init(data["alarmSiren"])
        treeTiltSensor = TreeTiltSensor.init(data["treeTiltSensor"])
        deviceDescription = data["description"].stringValue
        installationDateServer = data["installationDate"].stringValue
        installationDate = data["installationDate"].stringValue.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").dateToString("MM/dd/yyyy")
        updatedAt = data["updatedAt"].stringValue.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").dateToString("MM/dd/yyyy")
        location = data["location"].stringValue
        treeTiltSensorId = data["treeTiltSensorId"].stringValue
        propertyInfo = PropertyInfo.init(data["Property"])
    }
}


///
class TreeTiltSensor: NSObject {
    ///
    var treeId: String = ""
    ///
    var treeType: String = ""
    ///
    var treeHeight: String = ""
    ///
    var safeZoneArea: String = ""
    ///
    var currentY :String = ""
    ///
    var currentZ :String = ""
    ///
    var id: String = ""
    ///
    var dbh: String = ""
    ///
    var upperY: String = ""
    ///
    var upperZ: String = ""
    ///
    var alarms: [Alarms]?
}

///
extension TreeTiltSensor {
    ///
    convenience init(_ data: JSON) {
        self.init()
        treeId = data["treeId"].stringValue
        treeType = data["treeType"].stringValue
        treeHeight = data["treeHeight"].stringValue
        safeZoneArea = data["safeZoneArea"].stringValue
        currentY = data["currentY"].stringValue
        currentZ = data["currentZ"].stringValue
        id = data["id"].stringValue
        dbh = data["dbh"].stringValue
        upperY = data["upperY"].stringValue
        upperZ = data["upperZ"].stringValue
        if let alarms = data["alarms"].array {
            var updatedAlarm: [Alarms] = []
            for alarm in alarms {
                if !alarm.isEmpty {
                    updatedAlarm.append(Alarms(alarm))
                }
            }
            self.alarms = updatedAlarm
        }
    }
}


///
class AlarmSiren: NSObject {
    ///
    var sirenId: String = ""
    ///
    var sirenName: String = ""
    ///
    var endDeviceType: String = ""
    ///
    var name: String = ""
}

///
extension AlarmSiren {
    ///
    convenience init(_ data: JSON) {
        self.init()
        sirenId = data["sirenId"].stringValue
        sirenName = data["sirenName"].stringValue
        endDeviceType = data["endDeviceType"].stringValue
        name = data["name"].stringValue
    }
}

class Alarms : NSObject{
    ///
    var sirenId: String = ""
    ///
    var sirenName: String = ""
    ///
    var endDeviceId: Int = 0
    ///
    var id: Int = 0
}

extension Alarms{
    
    convenience init(_ data: JSON) {
        self.init()
        sirenId = data["sirenId"].stringValue
        sirenName = data["sirenName"].stringValue
        endDeviceId = data["endDeviceId"].intValue
        id = data["id"].intValue
    }
    
}
