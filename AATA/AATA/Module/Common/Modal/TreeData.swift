//
//  TreeData.swift
//  AATA
//
//  Created by M1 on 25/03/22.
//

import UIKit
import SwiftyJSON

class TreeData: NSObject {
    
    var treeTypes :  [TreeType]?

}

class TreeType: NSObject {
    var displayName: String = ""
    var name: String = ""
}


extension TreeData{
    
    convenience init(_ data: JSON){
        self.init()
        if let treeType = data["treeTypes"].array{
            for i in treeType{
                treeTypes = treeType.map({return TreeType($0)})
            }
        }
    }
    
}

extension TreeType{
   convenience init(_ data: JSON){
        self.init()
       displayName = data["displayName"].stringValue
       name = data["name"].stringValue
    }
}
