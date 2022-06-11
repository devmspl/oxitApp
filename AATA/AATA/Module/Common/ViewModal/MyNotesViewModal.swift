//
//  MyNotesViewModal.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//

import UIKit
import SwiftyJSON

///
class MyNotesViewModal: NSObject {
    ///
    func getNotesAPI(_ completion: @escaping([Notes], Bool) -> Void) {
        APIServices.shared.getNotesAPI { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
}
