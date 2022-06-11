//
//  WeatherCell.swift
//  AATA
//
//  Created by Uday Patel on 30/09/21.
//

import UIKit

class WeatherCell: UITableViewCell {
    ///
    @IBOutlet weak var titleLabel1: UILabel!
    ///
    @IBOutlet weak var titleLabel2: UILabel!
    ///
    @IBOutlet weak var valueLabel1: UILabel!
    ///
    @IBOutlet weak var valueLabel2: UILabel!
    ///
    @IBOutlet weak var dateLabel: UILabel!
    ///
    @IBOutlet weak var weatherIcon: UIImageView!
    ///
    @IBOutlet weak var dataNotAvialableLabel: UILabel!
    
    @IBOutlet weak var indicator_View: UIView!
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        
    }
    
    ///
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /*
     Soil moisture: Highest
     Temperature; lowest
     Precipitation: highest
     Wind: highest
     */
    
    ///
    ///Range -- 0.12-0.17
    func configuredSoilMoistureData(_ data: [String: Any]) {
        titleLabel1.text = "Average Moisture"
        titleLabel2.text = "Current Moisture"
        valueLabel1.text = "\(data["min_sg"] ?? "")-\(data["max_sg"] ?? "")"
        valueLabel2.text = "\(data["max_sg"] ?? "")"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_drops_green")
        let soilMoistureValue = data["max_sg"] as? Double ?? 0.0
        if soilMoistureValue > 0.096 && soilMoistureValue < 0.204 {
            self.indicator_View.backgroundColor = UIColor.systemGreen
        }else if soilMoistureValue > 0.078 && soilMoistureValue < 0.096 || soilMoistureValue > 0.204 && soilMoistureValue < 0.229{
            self.indicator_View.backgroundColor = UIColor.systemYellow
        }else{
            self.indicator_View.backgroundColor = UIColor.systemRed
        }
    }
    
    ///
    ///Range -- 36° F - 84° F
    func configureTemperatureData(_ data: [String: Any]) {
        titleLabel1.text = "Average Temperature"
        titleLabel2.text = "Current Temperature"
        let minTempToFahrenheit = ((data["min_sg"] as? Double ?? 0.0) * 1.8) + 32.00
        let maxTempToFahrenheit = ((data["max_sg"] as? Double ?? 0.0) * 1.8) + 32.00
        valueLabel1.text = "\(Double(round(100 * minTempToFahrenheit) / 100))°F-\(Double(round(100 * maxTempToFahrenheit) / 100))°F"
        valueLabel2.text = "\(Double(round(100 * minTempToFahrenheit) / 100))°F"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_temp_green")
        // -20% of 36° = 28.8 -- +20% of 36° = 43.2 && -20% of 84° = 67.2 -- +20% of 84° = 100.8
        if minTempToFahrenheit > 28.8 &&  minTempToFahrenheit < 43.2 || minTempToFahrenheit > 67.2 &&  minTempToFahrenheit < 100.8 {
            self.indicator_View.backgroundColor = UIColor.systemGreen
        }else if minTempToFahrenheit > 23.4 && minTempToFahrenheit < 28.8 || minTempToFahrenheit > 43.2 && minTempToFahrenheit < 48.6 || minTempToFahrenheit > 54.6 && minTempToFahrenheit < 67.2 || minTempToFahrenheit > 100.8 && minTempToFahrenheit < 113.4 {
            self.indicator_View.backgroundColor = UIColor.systemYellow
        }else{
            self.indicator_View.backgroundColor = UIColor.systemRed
        }
    }
    
    ///
    ///Range -- 0.80 - 2.00
    func configuredPrecipitationData(_ data: [String: Any]) {
        titleLabel1.text = "Average Precipitation"
        titleLabel2.text = "Current Precipitation"
        valueLabel1.text = "\(data["min_sg"] ?? "")%-\(data["max_sg"] ?? "")%"
        valueLabel2.text = "\(data["max_sg"] ?? "")%"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_weather_green")
        let precipitationValue = data["max_sg"] as? Double ?? 0.0

         if precipitationValue > 0.64 &&  precipitationValue < 0.96 || precipitationValue > 1.60 &&  precipitationValue < 2.40 {
             self.indicator_View.backgroundColor = UIColor.systemGreen
         }else if precipitationValue > 0.52 && precipitationValue < 0.64 || precipitationValue > 0.96 && precipitationValue < 1.08 || precipitationValue > 1.3 && precipitationValue < 1.6 || precipitationValue > 2.4 && precipitationValue < 2.7 {
             self.indicator_View.backgroundColor = UIColor.systemYellow
         }else{
             self.indicator_View.backgroundColor = UIColor.systemRed
         }
    }
    
    ///
    ///Range - 0.61mph - 5mph
    func configuredWindData(_ data: [String: Any]) {
        titleLabel1.text = "Average Wind"
        titleLabel2.text = "Max Wind"
        valueLabel1.text = "\(data["min_sg"] ?? "")mph-\(data["max_sg"] ?? "")mph"
        valueLabel2.text = "\(data["max_sg"] ?? "")mph"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_wind_green")

        let windValue = data["max_sg"] as? Double ?? 0.0
        if windValue > 0.49 &&  windValue < 0.73 || windValue > 4.00 &&  windValue < 6.00 {
            self.indicator_View.backgroundColor = UIColor.systemGreen
        }else if windValue > 0.40 && windValue < 0.49 || windValue > 0.73 && windValue < 0.82 || windValue > 3.25 && windValue < 4.00 || windValue > 6.00 && windValue < 6.75 {
            self.indicator_View.backgroundColor = UIColor.systemYellow
        }else{
            self.indicator_View.backgroundColor = UIColor.systemRed
        }
    }
}

