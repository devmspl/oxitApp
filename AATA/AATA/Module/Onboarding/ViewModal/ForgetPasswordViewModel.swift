//
//  ForgetPasswordViewModel.swift
//  AATA
//
//  Created by Macbook on 08/03/22.
//

import UIKit

class ForgetPasswordViewModel: NSObject {

    
    ///
    func forgetPasswordApi(param: [String: Any],_ completion: @escaping([String: Any], Bool) -> Void) {
        APIServices.shared.forgotPassword(param) { (response, isSuccess) in
            completion(response , isSuccess)
        }
    }
    
}
