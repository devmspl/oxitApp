//
//  SettingsViewModal.swift
//  AATA
//
//  Created by Uday Patel on 14/12/21.
//

import UIKit

///
class SettingsViewModal: NSObject {
    ///
    func getUserProfileAPI(_ completion: @escaping(UserProfile?, Bool) -> Void) {
        APIServices.shared.getUserProfileAPI { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    
    ///
    func getUsersAPI(_ completion: @escaping([UserManagement], Bool) -> Void) {
        APIServices.shared.getUsersAPI { (usersList, isSuccess) in
            completion(usersList, isSuccess)
        }
    }
    
    ///
    func deleteUserAPI(_ userId: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        APIServices.shared.deleteUserAPI(userId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
}
