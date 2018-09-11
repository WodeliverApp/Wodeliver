//
//  MyViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyViewController: UIViewController {

    //MARK: Public Variables
    struct SegmentDetail {
        var isCurrent = false
        var isHistory = false
        var isHistoryDetail = false
        var isHistoryNew = false
    }
    //MARK: Private Variables
    
    fileprivate var segmentDetail = SegmentDetail()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentView: MySegmentedControl!
    @IBOutlet weak var redBackgroundView: UIView!
    
    var currentOrderList : [JSON] = []
    var historyOrderList : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.viewCustomization()
        // Do any additional setup after loading the view.
        getCurrentOrderList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    func registerCustomCell()
    {
        self.myTableView.register(UINib(nibName: "CurrentOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentOrderTableViewCell")
        self.myTableView.register(UINib(nibName: "CurrentStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentStatusTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryDetailTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryNewTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryNewTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHeaderTableViewCell")
    }
    func viewCustomization(){
        self.mySegmentView.selectedSegmentIndex = 0
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.redBackgroundView.backgroundColor = Colors.redBackgroundColor
        //self.mySegmentView.backgroundColor = UIColor.white
        self.mySegmentView.addTarget(self, action: #selector(changeSegmentValue(sender:)), for: .valueChanged)
        segmentDetail.isCurrent = true
       // self.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        registerCustomCell()
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = Colors.redBackgroundColor
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
       
    }

    @objc func changeSegmentValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
             segmentDetail.isCurrent = true
            segmentDetail.isHistory = false
            segmentDetail.isHistoryDetail = false
            getCurrentOrderList()
        case 1:
            segmentDetail.isCurrent = false
            segmentDetail.isHistory = true
            segmentDetail.isHistoryDetail = false
            getOrderHistoryList()
        default: break
        }
        self.myTableView.reloadData()
    }

}
extension MyViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        if (segmentDetail.isHistory) || (segmentDetail.isHistoryDetail){
            return 1
        }else{
            return currentOrderList.count
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (segmentDetail.isHistory) || (segmentDetail.isHistoryDetail){
            return historyOrderList.count
        }else{
            if let items = currentOrderList[section]["items"].array{
                return items.count
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (segmentDetail.isHistory) || (segmentDetail.isHistoryDetail){
        return HistoryHeaderTableViewCell.getCellHeight()
        }else{
        return HistoryHeaderTableViewCell.getCellHeight()
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderTableViewCell") as! HistoryHeaderTableViewCell
        if segmentDetail.isHistory{
            headerCell.lblOrderNo.isHidden = true
            headerCell.backView.isHidden = false
        }else{
            headerCell.backView.isHidden = true
            headerCell.lblOrderNo.isHidden = false
            if let items = currentOrderList[section].dictionary{
                headerCell.lblOrderNo.text = "Order No. \(items["_id"]?.stringValue ?? "")"
            }
        }
        return headerCell
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentDetail.isCurrent{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentOrderTableViewCell") as! CurrentOrderTableViewCell
            cell.lblDate.text = OtherHelper.convertDateToString(date: currentOrderList[indexPath.section]["createdAt"].stringValue)
            if currentOrderList[indexPath.section]["orderAssigned"].dictionary != nil{
                cell.lblOrderStatus.text = "Order has been assigned to you"
            }else{
                cell.lblOrderStatus.text = ""
            }
            if let items = currentOrderList[indexPath.section]["items"].array{
                cell.lblItemName.text = items[indexPath.row]["item"].stringValue
                cell.imgItem.sd_setImage(with: URL(string:Path.baseURL + items[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            }
        return cell
        } else if segmentDetail.isHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
            cell.lblDate.text = OtherHelper.convertDateToString(date: historyOrderList[indexPath.row]["createdAt"].stringValue)
            cell.lblOrderNo.text = historyOrderList[indexPath.row]["_id"].stringValue
            cell.btnComment_ref.addTarget(self, action: #selector(btnComment_action(sender:)), for: .touchUpInside)
            return cell
        }
        else if segmentDetail.isHistoryDetail{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDetailTableViewCell") as! HistoryDetailTableViewCell
            return cell
        }else if segmentDetail.isHistoryNew{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryNewTableViewCell") as! HistoryNewTableViewCell
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentDetail.isCurrent{
            return CurrentOrderTableViewCell.getCellHeight()
        } else if segmentDetail.isHistory{
            return HistoryTableViewCell.getCellHeight()
        }else if segmentDetail.isHistoryDetail{
            return HistoryDetailTableViewCell.getCellHeight()
        }else if segmentDetail.isHistoryNew{
            return HistoryNewTableViewCell.getCellHeight()
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentDetail.isHistory{
            self.performSegue(withIdentifier: "historyToDetailVC", sender: historyOrderList[indexPath.row])
        }else if segmentDetail.isCurrent{
            //self.performSegue(withIdentifier: "currentToOrderStatus", sender: nil)
        }
    }
    
    @objc func btnComment_action(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.myTableView)
        if let indexPath = self.myTableView.indexPathForRow(at: buttonPosition){
            print(indexPath)
        }
      
    }
}

extension MyViewController{

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyToDetailVC"{
            if let order = sender as? JSON{
                if let destination = segue.destination as? HistoryDeatilViewController{
                    destination.order = order
                }
            }
        }
     }


}

extension MyViewController{
    //MARK: - Server Action
    
    func getCurrentOrderList()  {
        let urlStr = Path.baseURL+"deliveryBoy/order/current"
        NetworkHelper.get(url: urlStr, param: ["userId":UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.currentOrderList = json["response"].arrayValue
            if self.currentOrderList.count == 0{
                OtherHelper.simpleDialog("Error", "No current order found.", self)
            }else{
                self.myTableView.reloadData()
            }
        })
    }
    func getOrderHistoryList()  {
        let urlStr = Path.baseURL+"deliveryBoy/order/complete"
        NetworkHelper.get(url: urlStr, param: ["userId":UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
           // print(json)
            self.historyOrderList = json["response"].arrayValue
            if self.historyOrderList.count == 0{
                OtherHelper.simpleDialog("Error", "No history found.", self)
            }else{
                print(self.historyOrderList)
                print(self.historyOrderList.count)
                self.myTableView.reloadData()
            }
        })
    }
}
