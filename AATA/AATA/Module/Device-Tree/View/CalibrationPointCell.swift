//
//  CalibrationPointCell.swift
//  AATA
//
//  Created by M1 on 31/03/22.
//

import UIKit

class CalibrationPointCell: UITableViewCell {

    
    var deviceDetail: EndDeviceDetail?
    
    var viewModal: DeviceViewModel = DeviceViewModel()
    
    var dataSource : DeviceTreeDataSource?

    @IBOutlet weak var setCalibrationBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var currentZ: UITextField!
    @IBOutlet weak var currentY: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        dataSource?.type(of: init)
//        dataSource?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//extension CalibrationPointCell : Treedelegate{
//
//    func getCalibration(_ completion: @escaping (EndDeviceDetail?, Bool) -> ()) {
//        CommonMethods.showProgressHud(inView: self.parentViewController!.view)
//        guard let id = deviceDetail?.id else {return}
//        viewModal.getEndDeviceDetailAPI(endDeviceId: id) { response, isSuccess in
//            CommonMethods.hideProgressHud()
//            if isSuccess{
//              completion(response,true)
//            }else{
//                completion(response,false)
//            }
//        }
//    }
//
//    func setCalibration(currentY: Int,currentZ:Int, _ completion: @escaping (Bool) -> ()) {
//        CommonMethods.showProgressHud(inView: parentViewController!.view)
//        let para: [String:Any] = ["realY":currentY,"realZ":currentZ]
//        guard let id = deviceDetail?.id else {return}
//        viewModal.setCalibrationApi(para,id) { response, isSuccess in
//            CommonMethods.hideProgressHud()
//            if isSuccess{
//                completion(true)
//            }else{
//                print(response,"error")
//            }
//        }
//    }
//
//}
