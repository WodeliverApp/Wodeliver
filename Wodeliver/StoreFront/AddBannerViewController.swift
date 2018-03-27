//
//  AddBannerViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 26/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddBannerViewController: UIViewController {

    @IBOutlet weak var txtStartDate: FloatLabelTextField!
    @IBOutlet weak var txtEndDate: FloatLabelTextField!
    @IBOutlet weak var txtStartTime: FloatLabelTextField!
    @IBOutlet weak var txtEndTime: FloatLabelTextField!
    @IBOutlet weak var txtLocation: FloatLabelTextField!
    @IBOutlet weak var btnDone_ref: UIButton!
    @IBOutlet weak var btnClose_ref: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Action
    
    @IBAction func btnDone_Action(_ sender: Any) {
        
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
