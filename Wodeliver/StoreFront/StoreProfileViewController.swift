//
//  StoreProfileViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreProfileViewController: UIViewController {

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
