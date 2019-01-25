//
//  StoreHomeViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import ExpyTableView
import SwiftyJSON
class StoreHomeViewController: UIViewController {
    
    //    let dataRow : [[String:String]] = [["productName":"Pizza", "unit":"4 Unit","amount": "$ 40", "image": "pizza"], ["productName": "Pizza", "unit": "4 Unit", "amount": "$ 50", "image": "no_image"],["productName": "Pizza", "unit": "4 Unit", "amount": "$ 60", "image": "no_image"],["productName":"Pizza", "unit": "4 Unit", "amount": "$ 70", "image": "pizza"]]
    //
    
    // let headerTitles = ["  Customer Name  Time : 15 min before", "  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before", "  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before"]
    
    @IBOutlet weak var tblHome: ExpyTableView!
    
    var currentItemData : [JSON] = []
    var currentHeaderTitles :[String] = []
    var currentOrderList : [JSON] = []
    var historyItemData : [JSON] = []
    var historyHeaderTitles :[String] = []
    var historyOrderList : [JSON] = []
    var tabIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tblHome.dataSource = self
        tblHome.delegate = self
        tblHome.rowHeight = UITableViewAutomaticDimension
        tblHome.estimatedRowHeight = 55
        //Alter the animations as you want
        tblHome.expandingAnimation = .fade
        tblHome.collapsingAnimation = .fade
        tblHome.tableFooterView = UIView()
        self.viewCostomization()
        tabIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentOrderList()
    }
    
    func viewCostomization(){
        self.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func swtValueChange(_ sender: UISegmentedControl) {
        if  sender.selectedSegmentIndex == 0{
            tabIndex = 1
            self.getCurrentOrderList()
        }else if sender.selectedSegmentIndex == 1{
            tabIndex = 2
            self.getHistoryOrderList()
        }
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

//MARK: ExpyTableViewDataSourceMethods

extension StoreHomeViewController: ExpyTableViewDataSource {
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
extension StoreHomeViewController: ExpyTableViewDelegate {
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

extension StoreHomeViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

//MARK: UITableView Data Source Methods
extension StoreHomeViewController {
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
}

extension StoreHomeViewController{
    
    func getCurrentOrderList()  {
        let urlStr = Path.storeCurrentOrder+"5a38069dccec263d205cdb4d"
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
            self.tblHome.reloadData()
        })
    }
    func getHistoryOrderList()  {
        let urlStr = Path.storeHistorytOrder+"5a38069dccec263d205cdb4d"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.historyOrderList = []
            self.historyHeaderTitles = []
            self.historyItemData = []
            self.historyOrderList = json["response"].arrayValue
            for item in self.historyOrderList{
                self.historyHeaderTitles.append(" " + item["user"]["name"].stringValue + " Time: " + item["createdAt"].stringValue)
                self.historyItemData.append(item["items"])
                
            }
            self.tblHome.reloadData()
        })
    }
}
