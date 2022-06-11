//
//  WeatherListDataSource.swift
//  AATA
//
//  Created by Uday Patel on 03/10/21.
//

import UIKit

///
class WeatherListDataSource: NSObject {
    // MARK: - Variable
    ///
    private var cellIdentifier = "WeatherCell"
    ///
    var tableView: UITableView!
    ///
    private let refreshControl = UIRefreshControl()
    ///
    var weather: Weather = .soilMoisture
    ///
    var wList: [[String: Any]] = []
    ///
    var weatherDataList: WeatherData? {
        didSet {
            if let weatherDataList = self.weatherDataList {
                wList = getAverageWeatherDataList(weatherDataList)
                tableView.reloadData()
            }
        }
    }
    
    ///
    func getFromattedDate(_ dateString: String) -> String {
        let dateStringObject = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:dateStringObject)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    ///
    func getAverageWeatherDataList(_ weatherDataList: WeatherData) -> [[String: Any]] {
        var storedDate = ""
        var count = 0
        
        var list: [[String: Any]] = []
        
        var noaaList: [Double] = []
        var sgList: [Double] = []
        
        var min_noaa = 0.0
        var min_sg = 0.0
        var max_noaa = 0.0
        var max_sg = 0.0
        
        switch weather {
        case .soilMoisture:
            for (index, item) in weatherDataList.soilMoisture.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.soilMoisture.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .temperature:
            for (index, item) in weatherDataList.airTemperature.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.airTemperature.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .precipitation:
            for (index, item) in weatherDataList.precipitation.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.precipitation.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .wind:
            for (index, item) in weatherDataList.windSpeed.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.windSpeed.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .voltageDetector:
            break
        }
        print("list", list)
        return list
    }
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView, weather: Weather) {
        self.init()
        self.tableView = tableview
        self.weather = weather
        tableview.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        /*tableview.separatorStyle = .none*/
        tableview.estimatedRowHeight = 200
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.tableHeaderView?.removeFromSuperview()
        tableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableview.layoutIfNeeded()
        //
        // tableview.refreshControl = refreshControl
        // refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    ///
    @objc private func refreshData(_ sender: Any) {
    }
    
    ///
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    ///
    func getCellForTableView(index: Int) -> WeatherCell {
        let bundelName = cellIdentifier
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? WeatherCell else { return WeatherCell() }
        return cell
    }
}

extension WeatherListDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wList.count
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch weather {
        case .soilMoisture:
            let cell: WeatherCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.configuredSoilMoistureData(wList[indexPath.row])
            return cell
        case .temperature:
            let cell: WeatherCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.configureTemperatureData(wList[indexPath.row])
            return cell
        case .precipitation:
            let cell: WeatherCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.configuredPrecipitationData(wList[indexPath.row])
            return cell
        case .wind:
            let cell: WeatherCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.configuredWindData(wList[indexPath.row])
            return cell
        case .voltageDetector:
            let cell: WeatherCell = getCellForTableView(index: 0)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ///
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    ///
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    ///
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    ///
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    ///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) { }
    }
}
