//
//  MenuViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 03/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    var menuList : [JSON] = []
    var itemCategoryId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCostomization()
        self.menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        itemCategoryId = "5a37fbc17c67920e2ccebed4"
        getMenuList()
        menuTableView.separatorColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewCostomization(){
        self.title = "Menu"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getMenuList() {
        var urlStr:String = ""
        let lat = UserManager.getUserLatitude()
        let long = UserManager.getUserLongitude()
        let param = "itemCategory=\(itemCategoryId)\("&lat=")\(lat)\("&long=")\(long)"
        urlStr = "\(Path.menuListUrl)\(param)"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.menuList = json["response"].arrayValue
            if self.menuList.count == 0{
                self.dismiss(animated: true, completion: nil)
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.menuTableView.reloadData()
            }
        })
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
extension MenuViewController{
    // MARK: - UITableView Delegate and datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.lblMenuName.text = "\(menuList[indexPath.row]["item"].stringValue)"
        cell.lblPrice.text =  "Price : \(menuList[indexPath.row]["price"].stringValue)"
        cell.lblCommentConut.text = "Comments : \(menuList[indexPath.row]["commentsCount"].stringValue)"
        cell.lblSoldCount.text = "Sold : \(menuList[indexPath.row]["sold"].stringValue)"
        cell.menuImageView.sd_setImage(with: URL(string:Path.baseURL + menuList[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuTableViewCell.getCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
