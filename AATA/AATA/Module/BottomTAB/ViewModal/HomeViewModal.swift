//
//  HomeViewModal.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//
import UIKit
import SwiftyJSON
import PINCache

///
class HomeViewModal: NSObject {
    ///
    func getWeatherData(_ queryPoint:String,_ lat: String, _ long: String, _ queryString: String, _ completion: @escaping(WeatherData, Bool) -> Void) {
        let endDate = NSDate()
        let endUnixtime = endDate.timeIntervalSince1970
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        let startUnixtime = (startDate ?? Date()).timeIntervalSince1970
        
        if isCalledInLast12Hours(){
            if PINCache.shared.object(forKey: queryString) != nil{
                let weatherdata = PINCache.shared.object(forKey: queryString) as! [String:Any]
                completion(WeatherData.init(JSON(weatherdata)), true)
            }else{
                APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
                    self.saveLastServiceCalledDate()
                    PINCache.shared.setObject(response, forKey: queryString)
                    completion(WeatherData.init(JSON(response)), isSuccess)
                }
            }
        }else{
            PINCache.shared.removeAllObjects()
            APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
                self.saveLastServiceCalledDate()
                PINCache.shared.setObject(response, forKey: queryString)
                completion(WeatherData.init(JSON(response)), isSuccess)
            }
        }
    }
    
    func getEndDeviceAPI(propertyId: String, _ completion: @escaping([EndDevice], Bool) -> Void) {
        APIServices.shared.getEndDeviceAPI(propertyId: propertyId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    
    func saveLastServiceCalledDate() {
        UserDefaults.standard.set(Date(), forKey: "lastServiceCallDate")
    }
    
    func isCalledInLast12Hours() -> Bool {
        guard let lastDate = UserDefaults.standard.value(forKey: "lastServiceCallDate") as? Date else { return false }
        let timeElapsed: Int = Int(Date().timeIntervalSince(lastDate))
        return timeElapsed <  720 * 60 // 12 hours
    }
    
}
