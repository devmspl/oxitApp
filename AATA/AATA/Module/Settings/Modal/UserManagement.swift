//
//  UserManagement.swift
//  AATA
//
//  Created by Uday Patel on 14/12/21.
//

import UIKit
import SwiftyJSON

///
class UserManagement: NSObject {
    ///
    var email: String = "";
    ///
    var firstName: String = "";
    ///
    var id: Int = 0;
    ///
    var lastName: String = "";
    ///
    var name: String = "";
    ///
    var phoneNumber: String = "";
    ///
    var role: String = "";
    ///
    var status: String = "";
    ///
    var type: String = "";
    ///
    var cognitoId: String = ""
}

///
extension UserManagement {
    ///
    convenience init(_ data: JSON) {
        self.init()
        email = data["email"].stringValue
        id = data["id"].intValue
        firstName = data["firstName"].stringValue
        lastName = data["lastName"].stringValue
        name = data["name"].stringValue
        phoneNumber = data["phoneNumber"].stringValue
        role = data["role"].stringValue
        status = data["status"].stringValue
        type = data["type"].stringValue
        cognitoId = data[""].stringValue
    }
}
