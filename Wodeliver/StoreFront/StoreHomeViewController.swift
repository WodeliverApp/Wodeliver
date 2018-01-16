//
//  StoreHomeViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import ExpyTableView

class StoreHomeViewController: UIViewController {
    
    let sampleData = [["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"],
                      ["  Customer Name  Time : 15 min before", "Pizza", "4 Unit", "$ 50"]]
    
    let dataArray :[[String: Any]] = [["headerTitle": "  Customer Name  Time : 15 min before", "data":["productName":"Pizza", "unit":"4 Unit","price":"$ 50"]],["headerTitle": "  Customer Name  Time : 15 min before", "data":["productName":"Pizza", "unit":"4 Unit","price":"$ 50"]],["headerTitle": "  Customer Name  Time : 15 min before", "data":["productName":"Pizza", "unit":"4 Unit","price":"$ 50"]],["headerTitle": "  Customer Name  Time : 15 min before", "data":["productName":"Pizza", "unit":"4 Unit","price":"$ 50"]]]
    
    let dataRow : [[String:String]] = [["productName":"Pizza", "unit":"4 Unit","amount": "$ 40", "image": "pizza"], ["productName": "Pizza", "unit": "4 Unit", "amount": "$ 50", "image": "no_image"],["productName": "Pizza", "unit": "4 Unit", "amount": "$ 60", "image": "no_image"],["productName":"Pizza", "unit": "4 Unit", "amount": "$ 70", "image": "pizza"]]
    let headerTitles = ["  Customer Name  Time : 15 min before", "  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before", "  Customer Name  Time : 15 min before","  Customer Name  Time : 15 min before"]
    
    
    
    @IBOutlet weak var tblHome: ExpyTableView!
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
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        self.viewCostomization()
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
            
       }else if sender.selectedSegmentIndex == 1{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func orientationDidChange() {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
            tblHome.reloadSections(IndexSet(Array(tblHome.visibleSections.keys)), with: .none)
        default:break
        }
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
        cell.lblHeaderName.text = headerTitles[section]
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
            print("WILL EXPAND")
            
        case .willCollapse:
            print("WILL COLLAPSE")
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            print("DID COLLAPSE")
        }
    }
}

extension StoreHomeViewController {
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return (section % 3 == 0) ? "iPhone Models" : nil
    //    }
}

extension StoreHomeViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
        //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        //This solution obviously has side effects, you can implement your own solution from the given link.
        //This is not a bug of ExpyTableView hence, I think, you should solve it with the proper way for your implementation.
        //If you have a generic solution for this, please submit a pull request or open an issue.
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
        
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

//MARK: UITableView Data Source Methods
extension StoreHomeViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Row count for section \(section) is \(sampleData[section].count)")
        return dataRow.count + 2 // +1 here is for BuyTableViewCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalOrderTableViewCell.self)) as! TotalOrderTableViewCell
            cell.layoutMargins = UIEdgeInsets.zero
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
            cell.lblProductName.text = dataRow[indexPath.row]["productName"]
            cell.lblUnit.text = dataRow[indexPath.row]["unit"]
            cell.lblPrice.text = dataRow[indexPath.row]["amount"]
            cell.imgProduct.image = UIImage.init(named: dataRow[indexPath.row]["image"]!)
            cell.layoutMargins = UIEdgeInsets.zero
            cell.hideSeparator()
            return cell
        }
    }
}
