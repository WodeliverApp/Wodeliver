//
//  StorePointViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 09/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class StorePointViewController: UIViewController {

    @IBOutlet weak var segmentView: MySegmentedControl!
    @IBOutlet weak var storepointTableView: UITableView!
    
    var isItem:Bool! = true
    var comingFrom:String!
    var selectedItemId:String!
    var storeList: [JSON] = []
    var categoryList: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCustomCell()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Storepoint Listing"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.storepointTableView.backgroundColor = Colors.viewBackgroundColor
        self.view.backgroundColor = Colors.redBackgroundColor
         self.segmentView.addTarget(self, action: #selector(changeSegmentValue(sender:)), for: .valueChanged)
         if self.comingFrom == "store"{
            self.isItem = false
            self.segmentView.selectedSegmentIndex = 1
         }else{
             self.isItem = true
             self.segmentView.selectedSegmentIndex = 0
        }
        self.getDataFromServer()
    }
    
    func registerCustomCell()
    {
        self.storepointTableView.register(UINib(nibName: "StorepointListingCell", bundle: nil), forCellReuseIdentifier: "StorepointListingCell")
        self.storepointTableView.register(UINib(nibName: "SearchByItemCell", bundle: nil), forCellReuseIdentifier: "SearchByItemCell")
        
    }
    @IBAction func segmentValueChnage(_ sender: Any) {
    }
    @objc func changeSegmentValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
           isItem = true
        case 1:
            isItem = false
        default: break
        }
        self.storepointTableView.reloadData()
    }
    //MARK: - Server Action
    
    func getDataFromServer()  {
        //  ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        var urlStr:String! = ""
        let lat = "28.5622497"
        let long = "77.3846662"
        if !isItem{
        let param = "categoryId=\(selectedItemId!)\("&lat=")\(lat)\("&long=")\(long)"
        urlStr = "\(Path.storeListURL)\(param)"
        }else{
            let param = "itemCategory=\("5a37fc227c67920e2ccebeda")"
            urlStr = "\(Path.itemListURL)\(param)"
        }
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            print(json)
            if !self.isItem{
             }else{
            self.categoryList = json["response"].arrayValue
            }
            self.storepointTableView.reloadData()
        })
    }
}
extension StorePointViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isItem{
            return self.categoryList.count
        }else{
        return 5
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if isItem{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchByItemCell") as! SearchByItemCell
            cell.titleLbl.text = self.categoryList[indexPath.row]["item"].stringValue
            cell.priceLbl.text = String(self.categoryList[indexPath.row]["price"].intValue)
            cell.commentLbl.text = String(self.categoryList[indexPath.row]["commentsCount"].intValue)
            cell.soldLbl.text = String(self.categoryList[indexPath.row]["sold"].intValue)
            cell.itemImg.sd_setImage(with: URL(string:Path.baseURL + categoryList[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
        return cell
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StorepointListingCell") as! StorepointListingCell
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isItem{
        return SearchByItemCell.getCellHeight()
        }else{
           return StorepointListingCell.getCellHeight()
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isItem{
        }else{
        self.performSegue(withIdentifier: "storeListToDetail", sender: nil)
        }
    }
}
