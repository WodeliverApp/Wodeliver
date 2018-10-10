//
//  CustomerOrderViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 04/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import ExpyTableView
class CustomerOrderViewController: UIViewController {

    //MARK: Public Variables
    struct SegmentDetail {
        var isCurrent = false
        var isHistory = false
        var isHistoryDetail = false
        var isHistoryNew = false
    }
    
    fileprivate var segmentDetail = SegmentDetail()
    
  //  @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTableView: ExpyTableView!
    @IBOutlet weak var mySegmentView: MySegmentedControl!
    @IBOutlet weak var redBackgroundView: UIView!
    
    var currentItemData : [JSON] = []
    var currentHeaderTitles :[String] = []
    var currentOrderList : [JSON] = []
    var historyItemData : [JSON] = []
    var historyHeaderTitles :[String] = []
    var historyOrderList : [JSON] = []
    var tabIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 55
        myTableView.expandingAnimation = .fade
        myTableView.collapsingAnimation = .fade
        myTableView.tableFooterView = UIView()
       // self.viewCostomization()
        tabIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentOrderList()
    }
    
    func viewCostomization(){
        self.title = "Order List"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        if  sender.selectedSegmentIndex == 0{
            tabIndex = 1
            self.getCurrentOrderList()
        }else if sender.selectedSegmentIndex == 1{
            tabIndex = 2
            self.getHistoryOrderList()
        }
    }
//    @objc func changeSegmentValue(sender: UISegmentedControl) {
//        if  sender.selectedSegmentIndex == 0{
//            tabIndex = 1
//            self.getCurrentOrderList()
//        }else if sender.selectedSegmentIndex == 1{
//            tabIndex = 2
//            self.getHistoryOrderList()
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: ExpyTableViewDataSourceMethods

extension CustomerOrderViewController: ExpyTableViewDataSource {
    func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
        return true
    }
    
    func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoreHomeTableViewCell.self)) as! StoreHomeTableViewCell
        cell.lblHeaderName.text = currentHeaderTitles[section]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
}

//MARK: ExpyTableView delegate methods
extension CustomerOrderViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        
        switch state {
        case .willExpand:
            // print("WILL EXPAND")
            break
        case .willCollapse:
            // print("WILL COLLAPSE")
            break
        case .didExpand:
            // print("DID EXPAND")
            break
        case .didCollapse:
            // print("DID COLLAPSE")
            break
        }
    }
}

extension CustomerOrderViewController {
    
    //MARK: UITableView Data Source Methods
        func numberOfSections(in tableView: UITableView) -> Int {
            if tabIndex == 1{
                return currentHeaderTitles.count
            }else{
                return historyHeaderTitles.count // +1 here is for BuyTableViewCell
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tabIndex == 1{
                return currentItemData[section].count + 3
            }else{
                return historyItemData[section].count + 3 // +1 here is for BuyTableViewCell
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tabIndex == 1{
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalOrderTableViewCell.self)) as! TotalOrderTableViewCell
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.lblTotalAmount.text = self.currentOrderList[indexPath.section]["totalPrice"].stringValue
                    cell.showSeparator()
                    return cell
                }else  if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AgentConfirmCell.self)) as! AgentConfirmCell
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.showSeparator()
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListingTableViewCell.self)) as! HomeListingTableViewCell
                    
                    
                    cell.lblProductName.text = currentItemData[indexPath.section][indexPath.row - 1]["item"].stringValue
                    cell.lblUnit.text = currentItemData[indexPath.section][indexPath.row - 1]["qty"].stringValue
                    cell.lblPrice.text = currentItemData[indexPath.section][indexPath.row - 1]["amount"].stringValue
                    cell.imgProduct.sd_setImage(with: URL(string:Path.baseURL + currentItemData[indexPath.section][indexPath.row - 1]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.hideSeparator()
                    return cell
                }
            }else{
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalOrderTableViewCell.self)) as! TotalOrderTableViewCell
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.lblTotalAmount.text = self.historyOrderList[indexPath.section]["totalPrice"].stringValue
                    cell.showSeparator()
                    return cell
                }else  if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AgentConfirmCell.self)) as! AgentConfirmCell
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.showSeparator()
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListingTableViewCell.self)) as! HomeListingTableViewCell
                    
                    
                    cell.lblProductName.text = historyItemData[indexPath.section][indexPath.row - 1]["item"].stringValue
                    cell.lblUnit.text = historyItemData[indexPath.section][indexPath.row - 1]["qty"].stringValue
                    cell.lblPrice.text = historyItemData[indexPath.section][indexPath.row - 1]["amount"].stringValue
                    cell.imgProduct.sd_setImage(with: URL(string:Path.baseURL + historyItemData[indexPath.section][indexPath.row - 1]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
                    cell.layoutMargins = UIEdgeInsets.zero
                    cell.hideSeparator()
                    return cell
                }
            }
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
        //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
        
        tableView.deselectRow(at: indexPath, animated: false)
        //    print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section == 0 {
        //            return 55
        //        }
        //        if indexPath.row == tableView.numberOfSections - 1 || indexPath.row == indexPath.section {
        ////            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
        ////                return 100
        ////            }
        //            return 85
        //        }else{
        //        return 55
        //        }
        return 55
    }
}

extension CustomerOrderViewController{
    //MARK: - Server Action
    
    func getCurrentOrderList()  {
        let urlStr = Path.baseURL+("order/user/current?userId=\(UserManager.getUserId())&skip=0")
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.currentHeaderTitles = []
            self.currentItemData = []
            self.currentOrderList = json["response"].arrayValue
            for item in self.currentOrderList{
                let formatter = Foundation.DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                formatter.timeZone = TimeZone.init(abbreviation: "UTC")
                formatter.locale = Locale.init(identifier: "en_US")
                let date1  = formatter.date(from: item["createdAt"].string!)
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                formatter.dateFormat = "dd-MMM-yyyy hh:mm a"
                let resultTime = formatter.string(from: date1!)
                self.currentHeaderTitles.append(" " + item["user"]["name"].stringValue + " Time: " + resultTime)
                self.currentItemData.append(item["items"])
            }
            self.myTableView.reloadData()
        })
    }
    func getHistoryOrderList()  {
        let urlStr = Path.baseURL+("order/user/completed?userId=\(UserManager.getUserId())&skip=0")
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.historyOrderList = []
            self.historyHeaderTitles = []
            self.historyItemData = []
            self.historyOrderList = json["response"].arrayValue
            if self.historyOrderList.count > 0{
                for item in self.historyOrderList{
                    self.historyHeaderTitles.append(" " + item["user"]["name"].stringValue + " Time: " + item["createdAt"].stringValue)
                    self.historyItemData.append(item["items"])
                    
                }
            }else{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }
           
            self.myTableView.reloadData()
        })
    }
}
