//
//  NotificationDetailTableViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 13/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
class NotificationDetailTableViewController: UITableViewController {

    @IBOutlet weak var buttonView: UIView!
    var itemDetail : [String : JSON]!
    var itemList : [JSON] = []
    var orderAssign : [String:Any]!
    var storeInfo : [String:Any]!
    var shopperInfo : [String:Any]!
    var deliveryBoyStatus : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       registerCell()
       print(itemDetail)
        if deliveryBoyStatus == "0"{
            buttonView.isHidden = false
        }else{
            buttonView.isHidden = true
        }
        if let orderAssign = itemDetail["orderAssigned"]{
            self.orderAssign = orderAssign.dictionaryValue
        }
        if let shopper = itemDetail["user"]{
            shopperInfo = shopper.dictionaryValue
        }
        if let store = itemDetail["storeInfo"]{
            storeInfo = store.dictionaryValue
        }
        if let items = itemDetail["items"]{
            itemList = items.arrayValue
        }
         self.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: "AssignTableViewCell", bundle: nil), forCellReuseIdentifier: "AssignTableViewCell")
        tableView.register(UINib(nibName: "StoreInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreInfoTableViewCell")
        tableView.register(UINib(nibName: "ShopperTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopperTableViewCell")
        tableView.register(UINib(nibName: "ItemListTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemListTableViewCell")
        tableView.register(UINib(nibName: "HistoryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHeaderTableViewCell")
        tableView.register(UINib(nibName: "HistoryFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryFooterTableViewCell")
        tableView.register(UINib(nibName: "ShopperReguestTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopperReguestTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Order Details"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = color.cgColor
        tableView.layer.shadowOpacity = opacity
        tableView.layer.shadowOffset = offSet
        tableView.layer.shadowRadius = radius
        tableView.layer.cornerRadius = 5.0
        tableView.layer.shouldRasterize = true
        tableView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnAccept_Action(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : AcceptOrderViewController = storyboard.instantiateViewController(withIdentifier: "AcceptOrderViewController") as! AcceptOrderViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.view.backgroundColor = UIColor.clear.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            self.present(viewController, animated: false, completion: nil)
        }, completion: nil)
    }
    
    @IBAction func btnReject_Action(_ sender: UIButton) {
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
             return itemList.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if deliveryBoyStatus == "0"{
                let cell : ShopperReguestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShopperReguestTableViewCell") as! ShopperReguestTableViewCell
                cell.lblOrderNo.text = "OrderNo : \(itemDetail["_id"]?.stringValue ?? "")"
                cell.lblDeliveryCharge.text = "Delivery Fee : \(itemDetail["deliveryCost"]?.stringValue ?? "")"
                return cell
            }
            let cell : AssignTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AssignTableViewCell") as! AssignTableViewCell
            if orderAssign != nil{
                cell.lblDetails.sizeToFit()
                cell.lblDetails.numberOfLines = 0
                cell.lblDetails.text = "\(orderAssign["name"] ?? "") \n\(orderAssign["email"] ?? "")\n\(orderAssign["phone"] ?? "")"
                if let imageUrl = orderAssign["image"] as? JSON{
                    cell.imgAssign.sd_setImage(with: URL(string:Path.baseURL + imageUrl.stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                }
            }
            return cell
        }else if indexPath.section == 1{
            let cell : StoreInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoTableViewCell", for: indexPath) as! StoreInfoTableViewCell
            cell.lblDetails.sizeToFit()
            cell.lblDetails.numberOfLines = 0
            cell.lblDetails.text = "\(storeInfo["name"] ?? "") \n\(storeInfo["address"] ?? "") \(storeInfo["city"] ?? "")\n\(storeInfo["country"] ?? "")\nPh: \(storeInfo["phone"] ?? "")"
            return cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopperTableViewCell") as! ShopperTableViewCell
            cell.lblDetails.sizeToFit()
            cell.lblDetails.numberOfLines = 0
            cell.lblDetails.text = "\(shopperInfo["name"] ?? "")\n\(shopperInfo["email"] ?? "")\nPh: \(shopperInfo["phone"] ?? "")"
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as! ItemListTableViewCell
            cell.lblName.text = itemList[indexPath.row]["item"].stringValue
            cell.lblQuantity.numberOfLines = 0
            cell.lblQuantity.sizeToFit()
            cell.lblQuantity.text = "\(itemList[indexPath.row]["qty"])\n(Unit Price- \(itemList[indexPath.row]["amount"].stringValue))"
            cell.lblPrice.text = itemList[indexPath.row]["price"].stringValue
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if deliveryBoyStatus == "0"{
                return 90
            }else{
                 return 160
            }
        }else if indexPath.section == 1{
            return 150
        }else if indexPath.section == 2{
            return 150
        }else{
            return 65
        }
    }
    
   override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3{
            return HistoryHeaderTableViewCell.getCellHeight()
        }
        return 0
    }
    
   override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderTableViewCell") as! HistoryHeaderTableViewCell
        headerCell.backView.isHidden = true
        headerCell.lblOrderNo.isHidden = false
    headerCell.lblOrderNo.text = "OrderNo: \(itemDetail["_id"]?.stringValue ?? "")"
        return headerCell
    }
    
   override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryFooterTableViewCell") as! HistoryFooterTableViewCell
    var finalPrice = 0
    for item in itemList{
        finalPrice = finalPrice + item["price"].intValue
    }
    footerCell.lblOrderAmount.text = String(finalPrice)
        return footerCell
    }
    
   override public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{return HistoryFooterTableViewCell.getCellHeight()}
        return 0
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 3{
//            return CGFloat.leastNormalMagnitude
//        }
//        return 18
//    }


}
