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
        self.addShadowToTableView()
       
    }
    func addShadowToTableView(){
//        //for table view border
        self.myTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.myTableView.layer.borderWidth = 1.0

        //for shadow
        let containerView:UIView = UIView(frame:self.myTableView.frame)
        //dont use clear color,fit blue color
        containerView.backgroundColor = UIColor.blue
        //shadow view also need cornerRadius
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: -1, height: 1) //Left-Bottom shadow
        //containerView.layer.shadowOffset = CGSizeMake(10, 10); //Right-Bottom shadow
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowRadius = 2

        //for rounded corners
        self.myTableView.layer.cornerRadius = 10
        self.myTableView.layer.masksToBounds = true
        self.view.addSubview(containerView)
        self.view.addSubview(self.myTableView)
        
//        self.myTableView.layer.shadowPath = UIBezierPath(rect: self.myTableView.bounds).cgPath
//        self.myTableView.layer.shadowColor = UIColor.black.cgColor
//        self.myTableView.layer.shadowOpacity = 1
//        self.myTableView.layer.shadowOffset = CGSize.zero
//        self.myTableView.layer.shadowRadius = 10
//        self.myTableView.clipsToBounds = false
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
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.myTableView.layer.masksToBounds = false
        self.myTableView.layer.shadowColor = color.cgColor
        self.myTableView.layer.shadowOpacity = opacity
        self.myTableView.layer.shadowOffset = offSet
        self.myTableView.layer.shadowRadius = radius
        self.myTableView.layer.cornerRadius = 5.0
        self.myTableView.layer.shouldRasterize = true
        self.myTableView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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
