//
//  AcceptOrderViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 21/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class AcceptOrderViewController: UIViewController {

    @IBOutlet weak var btnAccept_ref: CustomButton!
    @IBOutlet weak var btnCancel_ref: CustomButton!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblOrderAmount: UILabel!
    var responseData : JSON!
    var orderDetail : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        innerView.layer.cornerRadius = 5.0
        innerView.layer.borderWidth = 1.0
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        innerView.clipsToBounds = true
        self.getDepositDetail()
    }

    @IBAction func btnCancel_Action(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnAccept_Action(_ sender: UIButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AcceptOrderViewController{
    func getDepositDetail() {
        NetworkHelper.post(url: Path.depositAmount, param: ["userId": UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
           // self.loadMore = true
            guard let json = json else {
                return
            }
           
           print(json)
        })
    }
}
