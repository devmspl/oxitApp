//
//  PropertyViewModal.swift
//  AATA
//
//  Created by Uday Patel on 22/12/21.
//

import UIKit

class PropertyViewModal: NSObject {
    // MARK: - API Methods
    ///
    func getPropertyAPI(_ completion: @escaping([Property], Bool) -> Void) {
        APIServices.shared.getPropertyAPI { (response, isSuccess) in
            completion(response , isSuccess)
        }
    }
}
