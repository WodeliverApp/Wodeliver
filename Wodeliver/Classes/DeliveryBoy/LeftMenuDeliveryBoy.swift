//
//  LeftMenuDeliveryBoy.swift
//  Wodeliver
//
//  Created by Anuj Singh on 23/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeftMenuDeliveryBoy: UITableViewController {
    
    @IBOutlet weak var imgProfile: WodeliverImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    var profile : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // if view.tag != 1001{
        lblAddress.numberOfLines = 0
        lblAddress.sizeToFit()
        self.profile = UserManager.getDeliveryBoyProfile()
        lblAddress.text = "\(profile["name"].stringValue) \n \(profile["email"].stringValue)"
        //        if let address = UserDefaults.standard.value(forKey: AppConstant.currentUserLocation) as? [String : String]{
        //            lblAddress.text = address["full_address"]!
        //        }else{
        //            lblAddress.text = "Address"
        //        }
        //            let address : [String: String] = UserDefaults.standard.value(forKey: AppConstant.currentUserLocation) as! [String : String]
        //            lblAddress.text = address["full_address"]!
        imgProfile.sd_setImage(with: URL(string:Path.baseURL + (UserManager.getUserDetail()["image"].stringValue.replace(target: " ", withString: "%20"))), placeholderImage: UIImage(named: "no_image"))
        lblAddress.layoutIfNeeded()
        // }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // exit(10)
        if indexPath.section == 0{
            switch (indexPath.row){
            case 0:
                performSegue(withIdentifier: "profileDeliveryBoySegue", sender: nil)
            default:
                dismiss(animated: true, completion: nil)
            }
        }
        if indexPath.section == 1{
            switch (indexPath.row){
            case 2:
                performSegue(withIdentifier: "resetPasswordSegue", sender: nil)
            case 3:
                performSegue(withIdentifier: "settingSegue", sender: nil)
            case 4:
                performSegue(withIdentifier: "deliverBoyWallet", sender: nil)
            case 5:
                self.performSegue(withIdentifier: "notificationSegue", sender: nil)
            case 6:
                self.performSegue(withIdentifier: "addBankSegue", sender: nil)
            case 7:
                self.performSegue(withIdentifier: "transactionSegue", sender: nil)
            case 8:
                OtherHelper.buttonDialog("Confirm", "Are you sure to logout?", self, "Yes", true) {
                    UserManager.logout(isDisable: true)
                    
                    let strBoard = UIStoryboard(name: "Main", bundle: nil)
                    let logInViewController = strBoard.instantiateViewController(withIdentifier: "LoginViewController")
                    logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                    self.present(logInViewController, animated: true, completion: nil)
                    exit(0)
                }
            default:
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
