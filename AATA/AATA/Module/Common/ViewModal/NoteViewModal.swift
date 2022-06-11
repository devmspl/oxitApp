//
//  NoteViewModal.swift
//  AATA
//
//  Created by Uday Patel on 19/11/21.
//

import UIKit

///
class NoteViewModal: NSObject {
    ///
    func deleteNoteAPI(_ noteId: String, _ completion: @escaping([String: Any], Bool) -> Void) {
        APIServices.shared.deleteNoteAPI(noteId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
}
