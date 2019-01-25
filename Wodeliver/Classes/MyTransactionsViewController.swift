//
//  MyTransactionsViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblTransactions: UITableView!
    @IBOutlet weak var lblWalletAmount: UILabel!
    
    var transactionList : [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblTransactions.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        viewCustomization()
        getTransaction()
        tblTransactions.tableFooterView = UIView()
        lblWalletAmount.layer.cornerRadius = 4.0
        lblWalletAmount.clipsToBounds = true
    
    }
    
    func viewCustomization(){
        self.title = "Transactions"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.tblTransactions.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func getTransaction() {
        NetworkHelper.post(url: Path.baseURL + "getbanktransferrecords", param: ["userId": UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].dictionary{
                self.lblWalletAmount.text = response["walletBalance"]?.stringValue ?? ""
                if let transactions = response["list"]?.array{
                    self.transactionList = transactions
                    self.tblTransactions.reloadData()
                }
            }
            
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyTransactionsViewController{
    // MARK: - UITableView Delegate and datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        cell.lblTransactionDate.text = "Transaction Date : \(OtherHelper.convertDateToString(date: transactionList[indexPath.row]["createdAt"].stringValue))"
        cell.lblAmount.text = transactionList[indexPath.row]["amountToBeTransferred"].stringValue
        cell.lblBankName.text = transactionList[indexPath.row]["bankId"]["bankName"].stringValue
        cell.lblCustomerName.text = transactionList[indexPath.row]["bankId"]["accountHolderName"].stringValue
        cell.lblAccountNo.text = transactionList[indexPath.row]["bankId"]["accountNumber"].stringValue
        if transactionList[indexPath.row]["status"].stringValue == "0"{
            cell.lblStatus.text = "Pending"
        }else {
            cell.lblStatus.text = ""
        }
      //  let item = transactionList![indexPath.row]
//        if let result = item as? [String:Any] {
//            if let json = result["item"] {
//                let itemJson = JSON.init(parseJSON: json as! String)
//                cell.lblTitle.text = itemJson["item"].stringValue
//                cell.lblName.text = "Store : \(itemJson["storeId"]["name"].stringValue)"
//                cell.lblPrice.text = "Price : \(itemJson["price"].stringValue)"
//                cell.cartImageView.sd_setImage(with: URL(string:Path.baseURL + itemJson["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
//                if storesName.count == 0{
//                    storesName = itemJson["storeId"]["name"].stringValue
//                }else{
//                    if storesName.lowercased().range(of:itemJson["storeId"]["name"].stringValue) == nil {
//                        storesName = storesName + itemJson["storeId"]["name"].stringValue
//                    }
//                }
//            }
//            if let quantity = result["quantity"] as? String{
//                cell.lblItemCount.text = quantity
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
