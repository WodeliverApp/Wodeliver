//
//  MyViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    //MARK: Public Variables
    struct SegmentDetail {
        var isNotification = false
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
    override func viewDidLoad() {
        super.viewDidLoad()
      self.viewCustomization()
        // Do any additional setup after loading the view.
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
        self.myTableView.register(UINib(nibName: "CurrentTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentTableViewCell")
        self.myTableView.register(UINib(nibName: "CurrentStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentStatusTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryDetailTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryNewTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryNewTableViewCell")
        self.myTableView.register(UINib(nibName: "HistoryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHeaderTableViewCell")
    }
    func viewCustomization(){
        self.mySegmentView.selectedSegmentIndex = 1
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
           segmentDetail.isNotification = true
             segmentDetail.isCurrent = false
            segmentDetail.isHistory = false
            segmentDetail.isHistoryDetail = false
        case 1:
            segmentDetail.isCurrent = true
            segmentDetail.isHistory = false
            segmentDetail.isNotification = false
            segmentDetail.isHistoryDetail = false
        case 2:
            segmentDetail.isCurrent = false
            segmentDetail.isHistory = true
            segmentDetail.isNotification = false
            segmentDetail.isHistoryDetail = false
        default: break
        }
        self.myTableView.reloadData()
    }

}
extension MyViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (segmentDetail.isHistory) || (segmentDetail.isHistoryDetail){
            return 2
        }else{
            return 1
        }
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (segmentDetail.isHistory) || (segmentDetail.isHistoryDetail){
        return HistoryHeaderTableViewCell.getCellHeight()
        }else{
        return 0
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
        }
        return headerCell
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentDetail.isCurrent{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTableViewCell") as! CurrentTableViewCell
        return cell
        } else if segmentDetail.isHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
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
            return CurrentTableViewCell.getCellHeight()
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
            self.performSegue(withIdentifier: "historyToDetailVC", sender: nil)
        }else if segmentDetail.isCurrent{
            self.performSegue(withIdentifier: "currentToOrderStatus", sender: nil)
        }
    }
}
