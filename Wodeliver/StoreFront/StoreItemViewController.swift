//
//  StoreHistoryViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var segment_ref: UISegmentedControl!
    var storeItemList : [JSON] = []
    var storeAdvertismentList : [JSON] = []
    var bannerList : [JSON] = []
    var hotspotList : [JSON] = []
    var itemCategory = UserManager.getItemCategory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHistory.register(UINib(nibName: "StoreHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreHistoryTableViewCell")
        self.tblHistory.register(UINib(nibName: "AdvertismentTableViewCell", bundle: nil), forCellReuseIdentifier: "AdvertismentTableViewCell")
        self.viewCostomization()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshItemData(data:)), name:Notification.Name.init("refreshItemData") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBannerData(data:)), name:Notification.Name.init("refreshBannerData") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHotSpotData(data:)), name:Notification.Name.init("refreshHotSpotData") , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("refreshItemData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("refreshBannerData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("refreshHotSpotData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if segment_ref.selectedSegmentIndex == 0{
            self.getItemList()
        }else{
            self.getBannerList()
            self.getHotspotList()
        }
    }
    func viewCostomization(){
        self.title = "Store Management"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.tblHistory.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func refreshItemData(data: Notification) {
        self.getItemList()
    }
    @objc func refreshBannerData(data: Notification) {
        self.getBannerList()
    }
    @objc func refreshHotSpotData(data: Notification) {
        self.getHotspotList()
    }
    
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tblHistory.reloadData()
            getItemList()
        case 1:
            tblHistory.reloadData()
            self.getBannerList()
            self.getHotspotList()
        default:
            break
        }
    }
    
    @IBAction func addButton_Action(_ sender: Any) {
        if segment_ref.selectedSegmentIndex == 0{
            let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
            let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
            viewController.modalPresentationStyle = .overFullScreen
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.present(viewController, animated: false, completion: nil)
        }else if segment_ref.selectedSegmentIndex == 1{
            let alertController : UIAlertController = UIAlertController.init(title: "Choose Action", message: "", preferredStyle: .actionSheet)
            
            let addBanner : UIAlertAction = UIAlertAction.init(title: "Add Banner", style: .default, handler: {_ in
                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
                let viewController : AddBannerViewController = storyboard.instantiateViewController(withIdentifier: "AddBannerViewController") as! AddBannerViewController
                viewController.modalPresentationStyle = .overFullScreen
                viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.present(viewController, animated: false, completion: nil)
            })
            
            let addHotSpot : UIAlertAction = UIAlertAction.init(title: "Add HotSpot Item", style: .default, handler: {_ in
                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
                let viewController : AddHotspotViewController = storyboard.instantiateViewController(withIdentifier: "AddHotspotViewController") as! AddHotspotViewController
                viewController.modalPresentationStyle = .overFullScreen
                viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.present(viewController, animated: false, completion: nil)
            })
            let cancelAction : UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(addBanner)
            alertController.addAction(addHotSpot)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegate and datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if segment_ref.selectedSegmentIndex == 0 {
            return 1
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if segment_ref.selectedSegmentIndex == 0 {
            return self.storeItemList.count
        }else if section == 0{
            return self.bannerList.count
        }else{
            return self.hotspotList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
//        headerView.layer.borderColor = Colors.redBackgroundColor.cgColor
//        headerView.layer.borderWidth = 1
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textColor = Colors.redBackgroundColor
        if section == 0{
            headerLabel.text = "Banner"
        }else{
            headerLabel.text = "HotSpot Item"
        }
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segment_ref.selectedSegmentIndex == 0{
            return 0
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment_ref.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreHistoryTableViewCell") as! StoreHistoryTableViewCell
            let item = self.storeItemList[indexPath.row]
            cell.lblProductName.text = item["item"].stringValue
            cell.lblProductPrice.text = "\("Price: ")\(item["price"].stringValue)"
            cell.lblProdcutCategory.text = "\("Item Category: ")\(item["itemCategory"].arrayValue[0]["name"].stringValue)"  
            cell.lblDescription.text = "\("Description: ")\(item["description"].stringValue)"
            DispatchQueue.main.async {
                 cell.imgProduct.sd_setImage(with: URL(string:Path.baseURL + item["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertismentTableViewCell") as! AdvertismentTableViewCell
            if indexPath.section == 0{
                let bannerItem = self.bannerList[indexPath.row]
                cell.imgView.sd_setImage(with: URL(string:Path.baseURL + bannerItem["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                let timeSlot = bannerItem["slot"]["slotList"].array
                var timeSlotArray :[String] = []
                for item in timeSlot!{
                    timeSlotArray.append(item["slot"].stringValue)
                }
                cell.lblTime.text = timeSlotArray.map { String($0) }.joined(separator: ", ")
                cell.lblPrice.text = bannerItem["price"].stringValue + " $"
                cell.lblLocation.text = BannerTypeString(rawValue: bannerItem["location"].intValue )?.description
            }else{
                let hotSpotItem = self.hotspotList[indexPath.row]
                cell.imgView.sd_setImage(with: URL(string:Path.baseURL + hotSpotItem["item"]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                let timeSlot = hotSpotItem["slot"]["slotList"].array
                var timeSlotArray :[String] = []
                for item in timeSlot!{
                    timeSlotArray.append(item["slot"].stringValue)
                }
                cell.lblTime.text = timeSlotArray.map { String($0) }.joined(separator: ", ")
                cell.lblPrice.text = hotSpotItem["price"].stringValue + " $"
                cell.lblLocation.text = BannerTypeString(rawValue: hotSpotItem["location"].intValue )?.description
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segment_ref.selectedSegmentIndex == 0 {
            return StoreHistoryTableViewCell.getCellHeight()
        }else{
            return StoreHistoryTableViewCell.getCellHeightAdvertisment()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if segment_ref.selectedSegmentIndex == 0 {
            let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
                self.deleteStoreItem(itemId: self.storeItemList[indexPath.row]["_id"].stringValue, indexPath: indexPath)
                
            }
            delete.backgroundColor = Colors.redBackgroundColor
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
                let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
                viewController.itemObject = self.storeItemList[indexPath.row].dictionaryValue
                viewController.modalPresentationStyle = .overFullScreen
                viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.present(viewController, animated: false, completion: nil)
            }
            edit.backgroundColor = UIColor.gray
            return [delete, edit]
        }
        return nil
    }
    
}

extension StoreItemViewController{
    
    //MARK: - Server Action
    
    func getItemList()  {
        let urlStr = Path.storeMenuItem+"storeId=\(UserManager.getStoreId())"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.storeItemList = json["response"].arrayValue
            if self.storeItemList.count == 0{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                UserManager.setStoreItemList(detail: json["response"])
                self.tblHistory.reloadData()
            }
            
            
        })
    }
    
    func getBannerList()  {
        let urlStr = Path.bannerList+UserManager.getStoreId()
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.bannerList = json["response"].arrayValue
            if self.bannerList.count == 0{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.tblHistory.reloadData()
            }
        })
    }
    func getHotspotList()  {
        let urlStr = Path.hotspotList+UserManager.getStoreId()
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.hotspotList = json["response"].arrayValue
            if self.hotspotList.count == 0{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.tblHistory.reloadData()
            }
        })
    }
    
    func deleteStoreItem(itemId : String, indexPath : IndexPath)  {
        
        let alertController : UIAlertController = UIAlertController.init(title: "Confirm", message: "Are you sure to delete selected item ?", preferredStyle: .alert)
        
        let deleteAction : UIAlertAction = UIAlertAction.init(title: "Delete", style: .destructive, handler: {_ in
            NetworkHelper.get(url: Path.deleteItem + itemId , param: [:], self, completionHandler: {[weak self] json, error in
                guard let `self` = self else { return }
                guard (json != nil) else {
                    return
                }
                OtherHelper.simpleDialog("Success", "Item Deleted Sucessfully.", self)
                self.storeItemList.remove(at: indexPath.row)
                self.tblHistory.reloadData()
            })
        })
        let cancelAction : UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
