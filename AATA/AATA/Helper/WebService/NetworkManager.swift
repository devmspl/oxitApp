//
//  NetworkManager.swift
//  NPI
//
//  Created by Uday Patel on 01/07/20.
//  Copyright © 2020 jignesh. All rights reserved.
//

import UIKit
import Alamofire
import AWSMobileClient

///
class NetworkManager: NSObject {
    
    // MARK: - Variables
    ///
    var isReachable: Bool = false
    ///
    class var sharedInstance: NetworkManager {
        ///
        struct Static {
            ///
            static var instance: NetworkManager?
            ///
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = NetworkManager()
        }
        return Static.instance ?? NetworkManager() // change
    }
    
    // MARK: - Initializer
    ///
    override init() {
        super.init()
        do {
            // Reachability code
            let manager = NetworkReachabilityManager(host: "www.apple.com")
            
            manager?.startListening { status in
                print("Network Status Changed: \(status)")
                if status == .notReachable {
                    self.isReachable = false
                } else if status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi) {
                    self.isReachable = true
                }
            }
        } catch { }
    }
    
    /// Download file from server.
    ///
    /// - Parameters:
    ///   - url: file ur.
    ///   - destinationFolder: destination folder name.
    ///   - completion: completion object.
    func downloadFile(_ url: URL, destinationFolder: String, _ completion: @escaping (Bool) -> Void) {
        do {
            let documentsDirectoryURL = try FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dirPath = documentsDirectoryURL.appendingPathComponent(destinationFolder + "/")
            let destinationPath = dirPath.appendingPathComponent(url.lastPathComponent)
            try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
            let fileData = try Data(contentsOf: url)
            try fileData.write(to: destinationPath)
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
    /// requestFor
    ///
    /// - Parameters:
    ///   - url: url
    ///   - param: parameters
    ///   - httpMethod: httpMethod
    ///   - includeHeader: headerParameters
    ///   - encodingType: encodingType
    ///   - success: success Response
    ///   - failure: failure Response
    func requestFor(url: String, param: [String: Any]?, httpMethod: HTTPMethod, includeHeader: Bool, encodingType: ParameterEncoding = URLEncoding.default, customHeader: HTTPHeaders? = nil, success: @escaping (_ response: [String: Any], _ statusCode: Int) -> Void, failure: @escaping (_ response: [String: Any], _ statusCode: Int) -> Void) {
        var headerParam: HTTPHeaders?
        if includeHeader {
            AWSMobileClient.default().getTokens { (tokens, error) in
                if let newToken = tokens?.idToken?.tokenString {
                    SharedDataManager.shared.idToken = newToken
                }
                headerParam = self.getHeaderParam()
                self.requestFor(url: url, param: param, httpMethod: httpMethod, headerParam: headerParam, encodingType: encodingType, success: success, failure: failure)
            }
        } else {
            headerParam = customHeader
            requestFor(url: url, param: param, httpMethod: httpMethod, headerParam: headerParam, encodingType: encodingType, success: success, failure: failure)
        }
    }
    
    /// requestFor
    ///
    /// - Parameters:
    ///   - url: url
    ///   - param: parameters
    ///   - httpMethod: httpMethod
    ///   - headerParam: headerParameters
    ///   - encodingType: encodingType
    ///   - success: success Response
    ///   - failure: failure Response
    fileprivate func requestFor(url: String, param: [String: Any]?, httpMethod: HTTPMethod, headerParam: HTTPHeaders?, encodingType: ParameterEncoding = URLEncoding.default, success:@escaping (_ response: [String: Any], _ statusCode: Int) -> Void, failure:@escaping (_ response: [String: Any], _ statusCode: Int) -> Void) {
        if isReachable {
            AF.session.configuration.timeoutIntervalForRequest = 60.0
            AF.session.configuration.timeoutIntervalForResource = 60.0
            AF.request(url, method: httpMethod, parameters: param, encoding: encodingType, headers: headerParam).responseJSON { response in
                print(param ?? "param empty")
                debugPrint(response)
                
                /*
                if let headers = response.response?.allHeaderFields as? [String: String] {
                    // These values are saved in user defaults
                    print(headers)
                }
                print(response.result)
                */
                let statusCode = response.response?.statusCode ?? 0
                switch response.result {
                case .success:
                    guard let responseDict = response.value as? [String: Any] else {
                        failure(["code": 0, "message": R.string.localizable.somethingWentWrongPleaseTryAgainLater()], statusCode)
                        return
                    }
                    success(responseDict, statusCode)
                case .failure:
                    failure(["code": 0, "message": response.error?.localizedDescription ?? R.string.localizable.somethingWentWrongPleaseTryAgainLater()], statusCode)
                }
            }
        } else {
            DispatchQueue.main.async {
                failure(["code": 0, "message": R.string.localizable.thisAppRequiresAnInternetConnectionMakeSureYouHaveCellServiceOrWifiConnectionAndGiveItAnotherTry()], 400)
            }
        }
    }
    
    /// Get Header Param.
    ///
    /// - Returns: HTTPHeaders.
    func getHeaderParam() -> HTTPHeaders {
        var headerParam: HTTPHeaders = [:]
        headerParam["client-id"] = "\(NetworkConfiguration.shared.clientId)"
        headerParam["platform"] = "mobile"
        headerParam["Content-Type"] = "application/json"
        if SharedDataManager.shared.idToken.trim().count > 0 {
            headerParam["Authorization"] = "Bearer" + " " + SharedDataManager.shared.idToken
        }
        return headerParam
    }
}
