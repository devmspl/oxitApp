//
//  Notes.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//

import UIKit
import SwiftyJSON

class AlertEndDevice: NSObject {
    ///
    var id: Int = 0
    ///
    var name: String = ""
    ///
    var deviceId: String = ""
    ///
    var endDeviceType: String = ""
    ///
    var treeId: String = ""
    
    ///
    convenience init(_ data: JSON) {
        self.init()
        id = data["id"].intValue
        name = data["name"].stringValue
        deviceId = data["deviceId"].stringValue
        endDeviceType = data["endDeviceType"].stringValue
        treeId = data["treeId"].stringValue
    }
}

///
class Alert: NSObject {
    ///
    var id: Int = 0
    ///
    var title: String = ""
    ///
    var alertDescription: String = ""
    ///
    var endDevice: AlertEndDevice = AlertEndDevice()
    ///
    var alertDate: String = ""
    ///
    var read: Bool = false
}

///
extension Alert {
    ///
    convenience init(_ data: JSON) {
        self.init()
        title = data["title"].stringValue
        id = data["id"].intValue
        alertDescription = data["description"].stringValue
        title = data["title"].stringValue
        endDevice = AlertEndDevice(data["EndDevice"])
        alertDate = data["alertDate"].stringValue
        read = data["read"].boolValue
    }
}
