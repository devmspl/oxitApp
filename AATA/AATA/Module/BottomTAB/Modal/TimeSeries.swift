//
//  TimeSeries.swift
//  AATA
//
//  Created by Uday Patel on 02/02/22.
//

import UIKit
import SwiftyJSON

///
class TimeSeries: NSObject {
    ///
    var measure_name: String = ""
    ///
    var measure_value: String = ""
    ///
    var realX: Float = 0
    ///
    var realY: Float = 0
    ///
    var realZ: Float = 0
    ///
    var timestamp: String = ""
}

///
extension TimeSeries {
    ///
    convenience init(_ data: JSON) {
        self.init()
        measure_name = data["measure_name"].stringValue
        measure_value = data["measure_value"].stringValue
        realX = data["realX"].floatValue
        realY = data["realY"].floatValue
        realZ = data["realZ"].floatValue
        timestamp = data["timestamp"].stringValue
    }
}

