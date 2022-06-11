//
//  Property.swift
//  AATA
//
//  Created by Uday Patel on 09/11/21.
//

import UIKit
import SwiftyJSON

///
class Property: NSObject {
    ///
    var assignedProperties: AssignedProperties?
    ///
    var clientInfo: ClientInfo?
    ///
    var addedBy: Int = 0
    ///
    var addressLine1: String = ""
    ///
    var addressLine2: String = ""
    ///
    var assignedUsersCount: Int = 0
    ///
    var createdAt: String = ""
    ///
    var updatedAt: String = ""
    ///
    var city: String = ""
    ///
    var clientId: Int = 0
    ///
    var country: String = ""
    ///
    var county: String = ""
    ///
    var id: Int = 0
    ///
    var latitude: Double = 0.0
    ///
    var location: String = ""
    ///
    var longitude: Double = 0.0
    ///
    var name: String = ""
    ///
    var state: String = ""
    ///
    var status: String = ""
    ///
    var timezone: String = ""
    ///
    var zip: Int = 0
    ///
    var devicesCount: Int = 0
    ///
    var gatewaysCount: Int = 0
    ///
    var stateCode = "<null>";
    ///
    var zonesCount: Int = 0
}

///
extension Property {
    ///
    convenience init(_ data: JSON) {
        self.init()
        assignedProperties = AssignedProperties.init(data["AssignedProperties"])
        clientInfo = ClientInfo.init(data["clients"])
        addedBy = data["addedBy"].intValue
        addressLine1 = data["addressLine1"].stringValue
        addressLine2 = data["addressLine2"].stringValue
        assignedUsersCount = data["assignedUsersCount"].intValue
        createdAt = data["createdAt"].stringValue
        updatedAt = data["updatedAt"].stringValue
        city = data["city"].stringValue
        clientId = data["clientId"].intValue
        country = data["country"].stringValue
        county = data["county"].stringValue
        id = data["id"].intValue
        devicesCount = data["devicesCount"].intValue
        gatewaysCount = data["gatewaysCount"].intValue
        zonesCount = data["zonesCount"].intValue
        stateCode = data["stateCode"].stringValue
        latitude = data["latitude"].doubleValue
        location = data["location"].stringValue
        longitude = data["longitude"].doubleValue
        name = data["name"].stringValue
        state = data["state"].stringValue
        status = data["status"].stringValue
        timezone = data["timezone"].stringValue
        zip = data["zip"].intValue
    }
    
    ///
    func formattedAddress() -> String {
        var addressString = ""
        if addressLine1.trim().count > 0 {
            addressString.append("\(addressLine1)")
        }
        if addressLine2.trim().count > 0 {
            addressString.append(", \(addressLine2)")
        }
        //addressString.append("\n")
        if addressLine1.trim() != city.trim(){
            if city.trim().count > 0 {
                addressString.append(", \(city)")
            }
        }
        if state.trim().count > 0 {
            addressString.append(", \(state)")
        }
        if zip != 0 {
            addressString.append(", \(zip)")
        }
        /*if country.trim().count > 0 {
            addressString.append(", \(country)")
        }*/
        return addressString
    }
}

///
class AssignedProperties: NSObject {
    ///
    var createdAt: String = ""
    ///
    var id: Int = 0
    ///
    var propertyId: Int = 0
    ///
    var updatedAt: String = ""
    ///
    var userId: Int = 0
}

///
extension AssignedProperties {
    ///
    convenience init(_ data: JSON) {
        self.init()
        createdAt = data["createdAt"].stringValue
        id = data["id"].intValue
        propertyId = data["propertyId"].intValue
        updatedAt = data["updatedAt"].stringValue
        userId = data["userId"].intValue
    }
}

/**
 success({
     data =     {
         records =         (
                         {
                 addedBy = 1009;
                 addressLine1 = "10267 Culpepper Court";
                 addressLine2 = "<null>";
                 assignedUsersCount = 1;
                 city = Harrisburg;
                 clientId = 503;
                 clients =                 {
                     companyName = "Arbor Alert";
                     projectName = AATA;
                 };
                 country = US;
                 county = US;
                 devicesCount = 0;
                 gatewaysCount = 0;
                 id = 825;
                 latitude = "35.2734558";
                 location = "<null>";
                 locationName = "<null>";
                 locationNumber = "<null>";
                 longitude = "-80.6494046";
                 name = "Andy's house";
                 state = "North Carolina";
                 stateCode = NC;
                 status = active;
                 timezone = "<null>";
                 zip = 28075;
                 zonesCount = 0;
             },
                         {
                 addedBy = 1005;
                 addressLine1 = "New Zealand";
                 addressLine2 = "<null>";
                 assignedUsersCount = 0;
                 city = "New Zealand";
                 clientId = 503;
                 clients =                 {
                     companyName = "Arbor Alert";
                     projectName = AATA;
                 };
                 country = GB;
                 county = GB;
                 devicesCount = 0;
                 gatewaysCount = 0;
                 id = 837;
                 latitude = "51.496813";
                 location = "<null>";
                 locationName = "<null>";
                 locationNumber = "<null>";
                 longitude = "-1.985503";
                 name = temp;
                 state = England;
                 stateCode = England;
                 status = active;
                 timezone = "<null>";
                 zip = "SN11 9JL";
                 zonesCount = 0;
             }
         );
         totalCount = 2;
     };
     message = "Properties list";
     status = success;
 })success({
 data =     {
     records =         (
                     {
             addedBy = 1009;
             addressLine1 = "10267 Culpepper Court";
             addressLine2 = "<null>";
             assignedUsersCount = 1;
             city = Harrisburg;
             clientId = 503;
             clients =                 {
                 companyName = "Arbor Alert";
                 projectName = AATA;
             };
             country = US;
             county = US;
             devicesCount = 0;
             gatewaysCount = 0;
             id = 825;
             latitude = "35.2734558";
             location = "<null>";
             locationName = "<null>";
             locationNumber = "<null>";
             longitude = "-80.6494046";
             name = "Andy's house";
             state = "North Carolina";
             stateCode = NC;
             status = active;
             timezone = "<null>";
             zip = 28075;
             zonesCount = 0;
         },
                     {
             addedBy = 1005;
             addressLine1 = "New Zealand";
             addressLine2 = "<null>";
             assignedUsersCount = 0;
             city = "New Zealand";
             clientId = 503;
             clients =                 {
                 companyName = "Arbor Alert";
                 projectName = AATA;
             };
             country = GB;
             county = GB;
             devicesCount = 0;
             gatewaysCount = 0;
             id = 837;
             latitude = "51.496813";
             location = "<null>";
             locationName = "<null>";
             locationNumber = "<null>";
             longitude = "-1.985503";
             name = temp;
             state = England;
             stateCode = England;
             status = active;
             timezone = "<null>";
             zip = "SN11 9JL";
             zonesCount = 0;
         }
     );
     totalCount = 2;
 };
 message = "Properties list";
 status = success;
})
 */
