//
//  UserProfile.swift
//  AATA
//
//  Created by Uday Patel on 15/12/21.
//

import UIKit
import SwiftyJSON

///
class UserProfile: NSObject {
    ///
    var email = "";
    ///
    var firstName = "";
    ///
    var id = 0;
    ///
    var lastName = "";
    ///
    var name = "";
    ///
    var phoneNumber = "";
    ///
    var role: String = "";
    ///
    var status: String = "";
    ///
    var type: String = "";
    ///
    var cognitoId: String = ""
    ///
    var userGroupId = 0;
    ///
    var userGroup: UserGroup = UserGroup([])
    ///
    var emailNotificationSetting = 0
    ///
    var pushNotificationSetting = 0
    ///
    var smsNotificationSetting = 0
}

enum UserGroupName: String {
    case mobileUser = "Andy Papa Mobile User"
    case customerUser = "Andy Papa Customer"
}

struct UserGroup {
    var name: String = ""
    var displayName: String = ""
    
    init(_ data: JSON) {
        name = data["name"].stringValue
        displayName = data["displayName"].stringValue
    }
}

///
extension UserProfile {
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
        cognitoId = data["cognitoId"].stringValue
        userGroupId = data["userGroupId"].intValue
        emailNotificationSetting = data["emailNotificationSetting"].intValue
        pushNotificationSetting = data["pushNotificationSetting"].intValue
        smsNotificationSetting = data["smsNotificationSetting"].intValue
        userGroup = UserGroup(data["UserGroup"])
    }
}
