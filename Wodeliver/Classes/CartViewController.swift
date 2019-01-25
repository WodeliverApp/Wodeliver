//
//  CartViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 25/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblCart: UITableView!
    var cartListItem = UserDefaults.standard.array(forKey: UserManager.cartItem)
    var storesName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblCart.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        viewCustomization()
        if UserDefaults.standard.array(forKey: UserManager.cartItem) != nil{
            cartListItem = UserDefaults.standard.array(forKey: UserManager.cartItem)
        }
        if (cartListItem?.count) != nil{
            
        }
        else{
            OtherHelper.simpleDialog("Error", "No cart item found.", self)
        }
    }
    
    func viewCustomization(){
        self.title = "Cart"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.tblCart.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPlaceOrder_Action(_ sender: Any) {
        //self.view = nil
       // OtherHelper.simpleDialog("Coming Soon", "Work in Progress", self)
        if !UserManager.checkIfLogin(){
            OtherHelper.simpleDialog("Error", "Please login before place order", self)
            return
        }
        self.performSegue(withIdentifier: "orderNowSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "orderNowSegue"{
            if let viewController = segue.destination as? OrderScreenViewController {
                do {
                    //Convert to Data
                    let jsonData = try JSONSerialization.data(withJSONObject: cartListItem ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
                    //Convert back to string. Usually only do this for debugging
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        let itemJson = JSON.init(parseJSON: JSONString )
                        print(itemJson)
                        viewController.cartList = itemJson
                        viewController.storeName = storesName
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
     }
    
    
}
extension CartViewController{
    // MARK: - UITableView Delegate and datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let count = cartListItem?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        
        let item = cartListItem![indexPath.row]
        if let result = item as? [String:Any] {
            if let json = result["item"] {
                let itemJson = JSON.init(parseJSON: json as! String)
                cell.lblTitle.text = itemJson["item"].stringValue
                cell.lblName.text = "Store : \(itemJson["storeId"]["name"].stringValue)"
                cell.lblPrice.text = "Price : \(itemJson["price"].stringValue)"
                cell.cartImageView.sd_setImage(with: URL(string:Path.baseURL + itemJson["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                if storesName.count == 0{
                   storesName = itemJson["storeId"]["name"].stringValue
                }else{
                    if storesName.lowercased().range(of:itemJson["storeId"]["name"].stringValue) == nil {
                        storesName = storesName + itemJson["storeId"]["name"].stringValue
                    }
                }
            }
            if let quantity = result["quantity"] as? String{
                cell.lblItemCount.text = quantity
            }
        }
        return cell
    }
}
