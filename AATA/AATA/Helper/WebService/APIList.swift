//
//  APIList.swift
//  NPI
//
//  Created by Uday Patel on 01/07/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit

/// This class consist all api url's used in app.
class APIList: NSObject {
    
    ///
    static let serverPath = NetworkConfiguration.shared.serverURL
    
    /// APIs for Register, Login, ForgotMpin
    struct Main {
        ///
        static let login = serverPath + "login"
        ///
        static let completeSignUp = serverPath + "users/complete-signup"
        ///
        static let property = serverPath + "properties"
        ///
        static let gateway = serverPath + "gateways?count=10&offset=0&propertyId="
        ///
        static let end_device = serverPath + "end-devices"
        ///
        static let get_end_device_detail = serverPath + "end-devices"
        ///
        static let getClientDetail = serverPath + "clients"
        ///
        static let zones = serverPath + "zones"
        ///
        static let getEndDeviceTypes = serverPath + "end-devices/get-end-device-types"
        ///
        static let alert = serverPath + "alerts"
        ///
        static let subscribe = serverPath + "notifications/subscribe"
        ///
        static let unsubscribe = serverPath + "notifications/unsubscribe"
        ///
        static let forgotPassword = serverPath + "forgot-password"
        ///
        static let confirmPassword = serverPath + "confirm-password"
        ///
        static let profile = serverPath + "users/profile"
        ///
        static let updateLeakStatus = serverPath + "update-leak-status/"
        ///
        static let glassStormWeather = NetworkConfiguration.shared.stormGlassHostURL
        ///
        static let createNote = serverPath + "notes"
        ///
        static let editNote = serverPath + "notes"
        ///
        static let getNotes = serverPath + "notes"
        ///
        static let deleteNote = serverPath + "notes"
        ///
        static let getUser = serverPath + "users"
        ///
        static let deleteUser = serverPath + "users"
        ///
        static let createUser = serverPath + "users"
        ///
        static let editProfile = serverPath + "users"
        ///
        static let getProfile = serverPath + "users/profile"
        ///
        static let timeseries = serverPath +  "timeseries"
        ///
        static let raiseAlarm = serverPath + "raise-siren/"
        ///
        static let createorDeleteEndDevice = serverPath + "end-devices"
        ///
        static let treeTypes = serverPath + "end-devices/get-tree-types"
        ///
        static let setCalibration = serverPath + "treesensor/"
        ///
        static let markAsReadAlert = serverPath + "alerts/read"
        ///
        static let getUnreadAlertCount = serverPath + "alerts/unread/count?propertyId="
        ///
        static let deletealerts = serverPath + "alerts/app"

    }
}
