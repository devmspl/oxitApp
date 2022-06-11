//
//  WeatherViewModal.swift
//  AATA
//
//  Created by Uday Patel on 02/11/21.
//

import UIKit
import SwiftyJSON
import PINCache
///
class WeatherViewModal: NSObject {
    ///
    func getWeatherData(_ queryPoint:String,_ lat: String, _ long: String, _ queryString: String, _ completion: @escaping(WeatherData, Bool) -> Void) {
        // weather/point?lat=58.7984&lng=17.8081&params=airTemperature,precipitation,windSpeed
        // bio/point?lat=19.0760&lng=72.8777&params=soilTemperature,soilMoisture
        //let endDate = NSDate() // current date
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        let endUnixtime = (endDate ?? Date()).timeIntervalSince1970
        let startOfDay = Calendar.current.date(bySettingHour: 00, minute: 01, second: 01, of: Date())
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: startOfDay ?? Date())
        let startUnixtime = (startDate ?? Date()).timeIntervalSince1970
        if isCalledInLast12Hours(){
            if PINCache.shared.object(forKey: queryString+lat+long) != nil{
                let weatherdata = PINCache.shared.object(forKey: queryString+lat+long) as! [String:Any]
                completion(WeatherData.init(JSON(weatherdata)), true)
            }else{
                APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
                    self.saveLastServiceCalledDate()
                    PINCache.shared.setObject(response, forKey: queryString+lat+long)
                    completion(WeatherData.init(JSON(response)), isSuccess)
                }
            }
        }else{
            PINCache.shared.removeObject(forKey: queryString+lat+long)
            APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
                self.saveLastServiceCalledDate()
                PINCache.shared.setObject(response, forKey: queryString+lat+long)
                completion(WeatherData.init(JSON(response)), isSuccess)
            }
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
