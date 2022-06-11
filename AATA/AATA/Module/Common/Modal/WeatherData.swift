//
//  WeatherData.swift
//  AATA
//
//  Created by Uday Patel on 01/11/21.
//

import UIKit
import SwiftyJSON

class WeatherData: NSObject {
    // MARK: - Variable
    ///
    var airTemperature: [AirTemperature] = []
    ///
    var precipitation: [Precipitation] = []
    ///
    var windSpeed: [WindSpeed] = []
    ///
    var soilMoisture: [SoilMoisture] = []
    ///
    var soilTemperature: [SoilTemperature] = []
    ///
    init(_ data: JSON) {
        super.init()
        for item in data["hours"].arrayValue {
            airTemperature.append(AirTemperature.init(item["airTemperature"], item["time"].stringValue))
            precipitation.append(Precipitation.init(item["precipitation"], item["time"].stringValue))
            windSpeed.append(WindSpeed.init(item["windSpeed"], item["time"].stringValue))
            soilMoisture.append(SoilMoisture.init(item["soilMoisture"], item["time"].stringValue))
            soilTemperature.append(SoilTemperature.init(item["soilTemperature"], item["time"].stringValue))
        }
    }
}

class AirTemperature: NSObject {
    // MARK: - Variable
    ///
    var dwd: Double = 0.0
    ///
    var noaa: Double = 0.0
    ///
    var sg: Double = 0.0
    ///
    var smhi: Double = 0.0
    ///
    var time: String = ""
    ///
    init(_ data: JSON, _ dateString: String) {
        super.init()
        dwd = data["dwd"].doubleValue
        noaa = data["noaa"].doubleValue
        sg = data["sg"].doubleValue
        smhi = data["smhi"].doubleValue
        time = dateString
    }
}

class Precipitation: NSObject {
    // MARK: - Variable
    ///
    var dwd: Double = 0.0
    ///
    var noaa: Double = 0.0
    ///
    var sg: Double = 0.0
    ///
    var smhi: Double = 0.0
    ///
    var time: String = ""
    ///
    init(_ data: JSON, _ dateString: String) {
        super.init()
        dwd = data["dwd"].doubleValue
        noaa = data["noaa"].doubleValue
        sg = data["sg"].doubleValue
        smhi = data["smhi"].doubleValue
        time = dateString
    }
}

class WindSpeed: NSObject {
    // MARK: - Variable
    ///
    var icon: Double = 0.0
    ///
    var noaa: Double = 0.0
    ///
    var sg: Double = 0.0
    ///
    var smhi: Double = 0.0
    ///
    var time: String = ""
    ///
    init(_ data: JSON, _ dateString: String) {
        super.init()
        icon = data["icon"].doubleValue
        noaa = data["noaa"].doubleValue
        sg = data["sg"].doubleValue
        smhi = data["smhi"].doubleValue
        time = dateString
    }
}

class SoilMoisture: NSObject {
    // MARK: - Variable
    ///
    var noaa: Double = 0.0
    ///
    var sg: Double = 0.0
    ///
    var time: String = ""
    ///
    init(_ data: JSON, _ dateString: String) {
        super.init()
        noaa = data["noaa"].doubleValue
        sg = data["sg"].doubleValue
        time = dateString
    }
}

class SoilTemperature: NSObject {
    // MARK: - Variable
    ///
    var noaa: Double = 0.0
    ///
    var sg: Double = 0.0
    ///
    var time: String = ""
    ///
    init(_ data: JSON, _ dateString: String) {
        super.init()
        noaa = data["noaa"].doubleValue
        sg = data["sg"].doubleValue
        time = dateString
    }
}
