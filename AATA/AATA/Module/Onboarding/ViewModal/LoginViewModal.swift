//
//  LoginViewModal.swift
//  AATA
//
//  Created by Uday Patel on 09/11/21.
//

import UIKit

///
class LoginViewModal: NSObject {
    // MARK: - API Methods
    ///
    func getPropertyAPI(_ completion: @escaping([Property], Bool) -> Void) {
        APIServices.shared.getPropertyAPI { (response, isSuccess) in
            completion(response , isSuccess)
        }
    }
    

    
}
