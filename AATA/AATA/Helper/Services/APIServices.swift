//
//  APIServices.swift
//  NPI
//
//  Created by Uday Patel on 11/07/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSMobileClient
import PINCache
///
class APIServices: NSObject {
    // MARK: - Variables
    ///
    static let shared = APIServices()
    ///
    let defaults = UserDefaults.standard
    ///
    // https://api.stormglass.io/v2/bio/point?lat=19.0760&lng=72.8777&params=soilTemperature,soilMoisture
    // https://api.stormglass.io/v2/weather/point?lat=58.7984&lng=17.8081&params=waveHeight,airTemperature,swellHeight,windSpeed,precipitation
    // https://api.stormglass.io/v2/weather/point?lat=58.7984&lng=17.8081&params=windSpeed
    // MARK: - Methods
    ///
    func loginAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.login, param: param, httpMethod: .post, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response, true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func getWeatherData(_ queryString: String, _ completion: @escaping([String: Any], Bool) -> Void) {

            let headerParam: HTTPHeaders = ["Authorization": NetworkConfiguration.shared.stormGlassAPIKey]
            NetworkManager.sharedInstance.requestFor(url: APIList.Main.glassStormWeather + queryString, param: nil, httpMethod: .get, includeHeader: false, encodingType: JSONEncoding.default, customHeader: headerParam) { (response, statusCode)  in
                guard statusCode == 200 else {
                    self.errorHandler(response)
                    completion([:] , false)
                    return
                }
               
                completion(response, true)
            } failure: { (error, statusCode)  in
                self.errorHandler(error)
                completion([:] , false)
            }
    }
    
   
    
    ///
    func getPropertyAPI(_ completion: @escaping([Property], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.property, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let data = response["data"] as? [String: Any], let dataList = data["records"] as? [[String: Any]] {
                var propertyList: [Property] = []
                for data in dataList {
                    propertyList.append(Property.init(JSON(data)))
                }
                completion(propertyList , true)
            } else {
                completion([] , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func getEndDeviceAPI(propertyId: String, _ completion: @escaping([EndDevice], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.end_device + "?" + "propertyId=\(propertyId)", param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let data = response["data"] as? [String: Any], let dataList = data["records"] as? [[String: Any]] {
                var endDeviceList: [EndDevice] = []
                for data in dataList {
                    endDeviceList.append(EndDevice.init(JSON(data)))
                }
                completion(endDeviceList , true)
            } else {
                completion([] , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func getEndDeviceDetailAPI(endDeviceId: String, _ completion: @escaping(EndDeviceDetail?, Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.get_end_device_detail + "/" + "\(endDeviceId)", param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(nil , false)
                return
            }
            if let data = response["data"] as? [String: Any] {
                completion(EndDeviceDetail.init(JSON(data)) , true)
            } else {
                completion(nil , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(nil , false)
        })
    }
    
    ///
    func getNotesAPI(_ completion: @escaping([Notes], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.getNotes, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let data = response["data"] as? [String: Any], let dataList = data["records"] as? [[String: Any]] {
                var notesList: [Notes] = []
                for item in dataList {
                    notesList.append(Notes.init(JSON(item)))
                }
                completion(notesList , true)
            } else {
                completion([] , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func createNoteAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createNote, param: param, httpMethod: .post, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func editNoteAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.editNote, param: param, httpMethod: .put, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func deleteNoteAPI(_ noteId: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.deleteNote + "/" + noteId, param: nil, httpMethod: .delete, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func getUsersAPI(_ completion: @escaping([UserManagement], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.getUser, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let data = response["data"] as? [String: Any], let dataList = data["records"] as? [[String: Any]] {
                var notesList: [UserManagement] = []
                for item in dataList {
                    notesList.append(UserManagement.init(JSON(item)))
                }
                completion(notesList , true)
            } else {
                completion([] , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func deleteUserAPI(_ userId: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.deleteUser + "/" + userId, param: nil, httpMethod: .delete, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func createUserAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createUser, param: param, httpMethod: .post, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func editUserProfile(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createUser, param: param, httpMethod: .put, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func getUserProfileAPI(_ completion: @escaping(UserProfile?, Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.getProfile, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(nil , false)
                return
            }
            if let data = response["data"] as? [String: Any] {
                
                completion(UserProfile.init(JSON(data)) , true)
            } else {
                completion(nil , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(nil , false)
        })
    }
    
    ///
    func getChartDataAPI(_ deviceId: String, _ startDate: String, _ toDate: String, _ completion: @escaping([TimeSeries], Bool) -> Void) {
        let selctedDevice = deviceId
        
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.timeseries + "/\(selctedDevice)?fromDate=\(startDate)&toDate=\(toDate)&timeZone=\(TimeZone.current.identifier)", param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let dataList = response["data"] as? [[String: Any]] {
                var timeSeries: [TimeSeries] = []
                for item in dataList {
                    timeSeries.append(TimeSeries.init(JSON(item)))
                }
                completion(timeSeries , true)
            } else {
                completion([] , false)
            }
            
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func loggedOutUserSession(_ completion: @escaping(Error?) -> Void) {
        SharedDataManager.shared.isLoggedIn = false
        AWSMobileClient.default().signOut()
        AWSMobileClient.default().signOut(options: SignOutOptions(signOutGlobally: true, invalidateTokens: true)) { (error) in
            completion(error)
            AWSMobileClient.default().clearKeychain()
        }
    }
    
    func raiseAlarmAPI(_ sirenID: String, _ completion: @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.raiseAlarm+sirenID, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response,true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    
    func forgotPassword(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.forgotPassword, param: param, httpMethod: .post, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response,true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func getAlertAPI(_ propertyId: String, _ completion: @escaping([Alert], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.alert + "?snoozed=false&status=active&sortColumn=alertDate&sortOrder=desc&" + "propertyId=\(propertyId)", param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { response, statusCode in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion([] , false)
                return
            }
            if let data = response["data"] as? [String: Any], let dataList = data["records"] as? [[String: Any]] {
                var alertList: [Alert] = []
                for data in dataList {
                    alertList.append(Alert.init(JSON(data)))
                }
                completion(alertList , true)
            } else {
                completion([] , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion([] , false)
        })
    }
    
    ///
    func deleteAlertAPI(_ alertId: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.alert + "/" + alertId, param: nil, httpMethod: .delete, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, code) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, code) in
            self.errorHandler(error)
            completion(error , false)
        })
        
    }
    
    ///
    func deleteAllAlertsAPI(param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
    NetworkManager.sharedInstance.requestFor(url: APIList.Main.deletealerts , param: param, httpMethod: .delete, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, code) in
        guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
            self.errorHandler(response)
            completion(response , false)
            return
        }
        completion(response , true)
    }, failure: { (error, code) in
        self.errorHandler(error)
        completion(error , false)
    })
}
    
    func createEndDevice(param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createorDeleteEndDevice, param: param, httpMethod: .post, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response,true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    func updateEndDevice(param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createorDeleteEndDevice, param: param, httpMethod: .put, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response,true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func deleteEndDeviceAPI(_ deviceID: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.createorDeleteEndDevice + "/" + deviceID, param: nil, httpMethod: .delete, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, code) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, code) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    func getGatewayInformation(propertyId: String, _ completion: @escaping(GatewayData?, Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.gateway+propertyId, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default) { (response, statusCode)  in
            guard statusCode == 200 else {
                self.errorHandler(response)
                completion(nil , false)
                return
            }
            if let data = response["data"] as? [String: Any]{
                completion(GatewayData.init(JSON(data)), true)
            }
        } failure: { (error, statusCode)  in
            self.errorHandler(error)
            completion(nil , false)
        }
    }
    ///
    func treeType(_ completion: @escaping(TreeData?, Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.treeTypes, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(nil , false)
                return
            }
            if let data = response["data"] as? [String: Any] {
                completion(TreeData.init(JSON(data)), true)
            } else {
                completion(nil , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(nil , false)
        })
    }
    ///
    func getEndDeveiceIdApi(_ queryString: String, _ completion: @escaping([String:Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.end_device + "?" + queryString, param: nil, httpMethod: .get, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            if let data = response["data"] as? [String: Any] {
                completion(data , true)
            }else{
                completion(response , false)
            }
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    ///
    func setCalibrationPoint(_ param: [String: Any],_ id: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.setCalibration + id, param: param, httpMethod: .put, includeHeader: true, encodingType: JSONEncoding.default, success: { (response, statusCode) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { (error, statusCode) in
            self.errorHandler(error)
            completion(error , false)
        })
    }
    
    ///
    func markAsReadAlert(_ param: [String : Any], _ completion: @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.markAsReadAlert, param: param, httpMethod: .put, includeHeader: true, encodingType: JSONEncoding.default, success: { ( response, isSuccess) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            completion(response , true)
        }, failure: { error, statusCode in
            self.errorHandler(error)
            completion(error, false)
        })

    }
    
    func getunreadAlertCount(_ propertyID : Int,_ completion : @escaping([String: Any], Bool) -> Void){
        NetworkManager.sharedInstance.requestFor(url: APIList.Main.getUnreadAlertCount+"\(propertyID)&snoozed=false&status=active", param: nil, httpMethod: .get, includeHeader: true, success: { ( response, isSuccess) in
            guard let status = response["status"] as? String, status.trim().lowercased() == "success" else {
                self.errorHandler(response)
                completion(response , false)
                return
            }
            if let data = response["data"] as? [String: Any]{
                completion(data , true)
            }
        }, failure: { error, statusCode in
            self.errorHandler(error)
            completion(error, false)
        })
}
    
}

