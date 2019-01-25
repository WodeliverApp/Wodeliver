//
//  LeftMenuTableViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 13/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SideMenu
class LeftMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var imgProfile: WodeliverImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if view.tag != 1001{
            lblAddress.numberOfLines = 0
            lblAddress.sizeToFit()
            let address : [String: String] = UserDefaults.standard.value(forKey: AppConstant.currentUserLocation) as! [String : String]
            lblAddress.text = address["full_address"]!
            imgProfile.sd_setImage(with: URL(string:Path.baseURL + (UserManager.getUserDetail()["image"].stringValue.replace(target: " ", withString: "%20"))), placeholderImage: UIImage(named: "no_image"))
            lblAddress.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let sideMenuNavigationController = segue.destination as? UISideMenuNavigationController {
//            sideMenuNavigationController.sideMenuManager = customSideMenuManager
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.view.tag == 1001{
            if indexPath.section == 0{
                switch (indexPath.row) {
                case 0:
                    dismiss(animated: true, completion: nil)
                    break
                case 1:
                    
                    break
                case 8:
                   dismiss(animated: true, completion: nil)
                    break
                default:
                    dismiss(animated: true, completion: nil)
                }
            }
        }else{
            if indexPath.section == 1 {
                switch (indexPath.row) {
                case 2:
                    performSegue(withIdentifier: "resetPasswordSegue", sender: nil)
                    break
                case 3:
                    performSegue(withIdentifier: "walletSegue", sender: nil)
                case 4:
                    self.performSegue(withIdentifier: "notificationSegue", sender: nil)
                    break
                case 5:
                    self.performSegue(withIdentifier: "orderSegue", sender: nil)
                    break
                case 6:
                    self.performSegue(withIdentifier: "addAddressSegue", sender: nil)
                    break
                case 7:
                    self.performSegue(withIdentifier: "transactionSegue", sender: nil)
                    break
                case 8:
                    OtherHelper.buttonDialog("Are you sure?", "Do you want to logout", self, "OK", true) {
                        UserManager.logout(isDisable: true)
                        self.dismiss(animated: true, completion: nil)
                        exit(0)
//                        let strBoard = UIStoryboard(name: "Main", bundle: nil)
//                        let logInViewController = strBoard.instantiateViewController(withIdentifier: "LoginViewController")
//                        logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//                        self.present(logInViewController, animated: true, completion: nil)
                    }
                    break
                default:
                   dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
   

}

