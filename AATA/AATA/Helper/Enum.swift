//
//  Enum.swift
//  AATA
//
//  Created by Uday Patel on 28/09/21.
//

///
enum DeviceTreeType: String {
    ///
    case deviceInfo = "Sensor Info"
    ///
    case treeInfo = "Tree Info"
    ///
    case sirenInfo = "Siren Info"
    ///
    case calibration = "Calibration"
}

///
enum Weather: String {
    ///
    case soilMoisture = "Soil Moisture"
    ///
    case temperature = "Temperature"
    ///
    case precipitation  = "Precipitation"
    ///
    case wind = "Wind"
    ///
    case voltageDetector = "Voltage Detector"
}

///
enum SettingsType: String {
    ///
    case profile = "Profile"
    ///
    case userManagement = "User Management"
    ///
    case sirenSettings = "Siren Settings"
}
