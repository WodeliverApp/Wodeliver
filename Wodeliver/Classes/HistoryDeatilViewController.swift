//
//  HistoryDeatilViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoryDeatilViewController: UIViewController {

    @IBOutlet weak var historyDetailTableView: UITableView!
    
    var order: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCustomCell()
        // Do any additional setup after loading the view.
        print(order)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.viewCostomization()
    }
    
    func viewCostomization(){
        self.title = "Order Detail"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func registerCustomCell(){
        self.historyDetailTableView.register(UINib(nibName: "HistoryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHeaderTableViewCell")
        self.historyDetailTableView.register(UINib(nibName: "HistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryDetailTableViewCell")
        self.historyDetailTableView.register(UINib(nibName: "HistoryFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryFooterTableViewCell")
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.historyDetailTableView.layer.masksToBounds = false
        self.historyDetailTableView.layer.shadowColor = color.cgColor
        self.historyDetailTableView.layer.shadowOpacity = opacity
        self.historyDetailTableView.layer.shadowOffset = offSet
        self.historyDetailTableView.layer.shadowRadius = radius
        self.historyDetailTableView.layer.cornerRadius = 5.0
        self.historyDetailTableView.layer.shouldRasterize = true
        self.historyDetailTableView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}
extension HistoryDeatilViewController: UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - UITableView Delegate and datasource Methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       if let item = order["items"].array{
            return item.count
        }
            return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return HistoryHeaderTableViewCell.getCellHeight()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderTableViewCell") as! HistoryHeaderTableViewCell
            headerCell.backView.isHidden = true
            headerCell.lblOrderNo.isHidden = false
        return headerCell
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryFooterTableViewCell") as! HistoryFooterTableViewCell
        footerCell.lblOrderAmount.text = order["price"].stringValue
        return footerCell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return HistoryFooterTableViewCell.getCellHeight()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailTableViewCell") as! HistoryDetailTableViewCell
        let item = order["items"].arrayValue
        cell.lblItemName.text = item[indexPath.row]["item"].stringValue
        cell.lblItemPrice.text = item[indexPath.row]["price"].stringValue
        cell.lblTotalItemAmount.text = item[indexPath.row]["amount"].stringValue
        cell.lblQuantity.text = item[indexPath.row]["qty"].stringValue
            return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return HistoryDetailTableViewCell.getCellHeight()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.performSegue(withIdentifier: "historyOrderToNewHistory", sender: nil)
    }
}
