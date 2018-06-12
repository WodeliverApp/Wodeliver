//
//  AddCartViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 26/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddCartViewController: UIViewController {
    
    @IBOutlet weak var btnIncreaseCount_ref: UIButton!
    @IBOutlet weak var btnDicreaseCount_ref: UIButton!
    @IBOutlet weak var btnCancel_ref: UIButton!
    @IBOutlet weak var btnAddCart_ref: UIButton!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    
    var itemCount : Int = 0
    var itemDetail : JSON!
    var itemName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnCancel_ref.layer.cornerRadius = 5.0
        btnCancel_ref.layer.borderColor = UIColor.darkGray.cgColor
        btnCancel_ref.layer.borderWidth = 0.5
        btnCancel_ref.clipsToBounds = true
        btnAddCart_ref.layer.cornerRadius = 5.0
        btnAddCart_ref.clipsToBounds = true
        itemCount = UserManager.getCartCount()
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         lblItemName.text = itemName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnIncreaseCount_Action(_ sender: UIButton) {
        let item = Int(lblItemCount.text!)! + 1
        lblItemCount.text = String(item)
    }
    
    @IBAction func btnDicreaseCount_Action(_ sender: UIButton) {
        var item = Int(lblItemCount.text!)!
        if item == 1{
            OtherHelper.simpleDialog("", "Minimum Quantity Reached", self)
            return
        }
        item = Int(lblItemCount.text!)! - 1
        lblItemCount.text = String(item)
    }
    
    @IBAction func btnAddCart_Action(_ sender: UIButton) {
        var addItemArray : Array<[String:Any]> = []
        var isItemFound : Bool = false
        let item : [String:Any] = ["item": self.itemDetail.rawString()!, "quantity":lblItemCount.text ?? "1","id" : self.itemDetail["_id"].stringValue]
        addItemArray.append(item)
        if UserDefaults.standard.array(forKey: UserManager.cartItem) == nil {
            UserDefaults.standard.set(addItemArray, forKey: UserManager.cartItem)
        }else{
            if var itemArr = UserDefaults.standard.array(forKey: UserManager.cartItem){
                if itemArr.count == 0{
                    UserDefaults.standard.set(addItemArray, forKey: UserManager.cartItem)
                }else{
                    for i in 0..<itemArr.count {
                        let item = itemArr[i]
                        if let result = item as? [String:Any] {
                            if let json = result["item"] {
                                let itemJson = JSON.init(parseJSON: json as! String)
                                if itemJson["_id"].stringValue == self.itemDetail["_id"].stringValue{
                                    itemArr.remove(at: i)
                                    itemArr.append(addItemArray.first! )
                                    isItemFound = true
                                    UserDefaults.standard.set(itemArr, forKey: UserManager.cartItem)
                                    break
                                }
                            }
                        }
                    }
                    
                }
                if !isItemFound{
                    itemArr.append(addItemArray.first!)
                    UserDefaults.standard.set(itemArr, forKey: UserManager.cartItem)
                }
            }
            
        }
        NotificationCenter.default.post(name: Notification.Name.init("cartItemRefresh"), object: nil, userInfo: nil)
     
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
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
