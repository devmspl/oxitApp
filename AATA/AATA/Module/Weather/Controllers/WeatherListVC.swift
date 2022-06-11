//
//  WeatherListVC.swift
//  AATA
//
//  Created by Uday Patel on 29/09/21.
//

import UIKit
import PINCache

class WeatherListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var weatherInfoTable: UITableView!
    
    // MARK: - Variables
    ///
    var dataSource: WeatherListDataSource?
    ///
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    ///
    var weather: Weather = .soilMoisture
    ///
    var viewModal: WeatherViewModal = WeatherViewModal.init()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        setupDataSource()
        getWeatherData()
    }
    
    ///
    func setupDataSource() {
        dataSource = WeatherListDataSource.init(withTableView: weatherInfoTable, weather: weather)
    }
    
    ///
    func reloadWeatherDataSource(_ weatherDataList: WeatherData) {
        guard dataSource?.weatherDataList == nil else { return }
        if dataSource == nil {
            setupDataSource()
        }
        dataSource?.weatherDataList = weatherDataList
        weatherInfoTable.reloadData()
    }
    
    ///
    func reloadEmptyDataSource() {
        dataSource?.weatherDataList = nil
        emptyDatasource.placeholderMessage = R.string.localizable.noRecordFound()
        weatherInfoTable.delegate = emptyDatasource
        weatherInfoTable.reloadData()
    }
    
    // MARK: - API Methods
    ///
    func getWeatherData() {
        var queryPoint = ""
        var queryString = ""
        var isHaveWeatherData = false
        switch weather {
        case .soilMoisture:
            queryPoint = "bio/point?"
            queryString = "soilMoisture"
            if Constants.soilMoistureWeatherList != nil {
                isHaveWeatherData = true
            }
        case .temperature:
            queryPoint = "weather/point?"
            queryString = "airTemperature"
            if Constants.temperatureWeatherList != nil {
                isHaveWeatherData = true
            }
        case .precipitation:
            queryPoint = "weather/point?"
            queryString = "precipitation"
            if Constants.precipitationWeatherList != nil {
                isHaveWeatherData = true
            }
        case .wind:
            queryPoint = "weather/point?"
            queryString = "windSpeed"
            if Constants.windWeatherList != nil {
                isHaveWeatherData = true
            }
        case .voltageDetector:
            queryPoint = ""
            queryString = ""
        }
        if let latitude = Constants.selectedProperty?.latitude, let longitude = Constants.selectedProperty?.longitude, queryString.trim().count != 0 {
            CommonMethods.showProgressHud(inView: view)
            viewModal.getWeatherData(queryPoint, "\(latitude)", "\(longitude)", queryString) { [weak self] (response, isSuccess) in
                CommonMethods.hideProgressHud()
                guard isSuccess else {
                    self?.reloadEmptyDataSource()
                    return
                }
                self?.setWeatherData(self?.weather ?? .soilMoisture, response)
                self?.reloadWeatherDataSource(response)
            }
            
        } else {
            reloadWithExistingWeatherData(weather)
        }
    }
    
    ///
    func setWeatherData(_ weather: Weather, _ response: WeatherData) {
        switch weather {
        case .soilMoisture:
            Constants.soilMoistureWeatherList = response
        case .temperature:
            Constants.temperatureWeatherList = response
        case .precipitation:
            Constants.precipitationWeatherList = response
        case .wind:
            Constants.windWeatherList = response
        case .voltageDetector:
            break
        }
    }
    
    ///
    func reloadWithExistingWeatherData(_ weather: Weather) {
        switch weather {
        case .soilMoisture:
            if let data = Constants.soilMoistureWeatherList {
                reloadWeatherDataSource(data)
            } else { reloadEmptyDataSource() }
        case .temperature:
            if let data = Constants.temperatureWeatherList {
                reloadWeatherDataSource(data)
            } else { reloadEmptyDataSource() }
        case .precipitation:
            if let data = Constants.precipitationWeatherList {
                reloadWeatherDataSource(data)
            } else { reloadEmptyDataSource() }
        case .wind:
            if let data = Constants.windWeatherList {
                reloadWeatherDataSource(data)
            } else { reloadEmptyDataSource() }
        case .voltageDetector:
            reloadEmptyDataSource()
        }
    }
}
