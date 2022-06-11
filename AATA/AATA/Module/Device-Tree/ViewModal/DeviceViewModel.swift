//
//  DeviceViewModel.swift
//  AATA
//
//  Created by Dhananjay on 08/12/21.
//

import UIKit

class DeviceViewModel: NSObject {

    ///
    func getEndDeviceAPI(propertyId: String, _ completion: @escaping([EndDevice], Bool) -> Void) {
        APIServices.shared.getEndDeviceAPI(propertyId: propertyId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    
    ///
    func getEndDeviceDetailAPI(endDeviceId: String, _ completion: @escaping(EndDeviceDetail?, Bool) -> Void) {
        APIServices.shared.getEndDeviceDetailAPI(endDeviceId: endDeviceId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    
    ///
    func raiseAlarmAPI(endDeviceID: String, _ completion : @escaping([String: Any],Bool) -> Void){
        APIServices.shared.raiseAlarmAPI(endDeviceID) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    ///
    func setCalibrationApi(_ param: [String:Any],_ id:String, _ completion: @escaping([String:Any],Bool)->()){
        APIServices.shared.setCalibrationPoint(param, id) { response, isSuccess in
            completion(response,isSuccess)
        }
    }
    
    ///
    func deleteEndDeviceApi(deviceID : String, _ completion : @escaping([String: Any] , Bool) -> ()){
        APIServices.shared.deleteEndDeviceAPI(deviceID) { response, isSuccess in
            completion(response,isSuccess)
        }
    }
    
}
