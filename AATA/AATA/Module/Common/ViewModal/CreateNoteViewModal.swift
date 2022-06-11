//
//  CreateNoteViewModal.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//

import UIKit
import SwiftyJSON

class CreateNoteViewModal: NSObject {
    ///
    func createNoteAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        APIServices.shared.createNoteAPI(param) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
    
    ///
    func editNoteAPI(_ param: [String: Any], _ completion: @escaping([String: Any], Bool) -> Void) {
        APIServices.shared.editNoteAPI(param) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
}
