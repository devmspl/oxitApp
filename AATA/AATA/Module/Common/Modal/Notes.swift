//
//  Notes.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//

import UIKit
import SwiftyJSON

///
class Notes: NSObject {
    ///
    var clientId: Int = 0
    ///
    var content: String = ""
    ///
    var createdBy: Int = 0
    ///
    var id: Int = 0
    ///
    var propertyId: Int = 0
    ///
    var status: String = ""
    ///
    var title: String = ""
    ///
    var updatedBy: String = ""
    ///
    var createdAt: Date?
}

///
extension Notes {
    ///
    convenience init(_ data: JSON) {
        self.init()
        clientId = data["clientId"].intValue
        content = data["content"].stringValue
        createdBy = data["createdBy"].intValue
        id = data["id"].intValue
        propertyId = data["propertyId"].intValue
        status = data["status"].stringValue
        title = data["title"].stringValue
        updatedBy = data["updatedBy"].stringValue
        createdAt = data["createdAt"].stringValue.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
}
