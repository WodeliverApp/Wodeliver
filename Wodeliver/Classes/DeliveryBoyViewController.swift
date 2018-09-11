//
//  DeliveryBoyViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 15/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
class DeliveryBoyViewController: UIViewController {

    @IBOutlet weak var notificationDBTableView: UITableView!
    
    var notification : [JSON] = []
    var page = 0
    var loadMore = false
    var size = 10
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registerCustomCell()
        getNotification()
        notificationDBTableView.tableFooterView = UIView()
        notificationDBTableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Notification"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        notificationDBTableView.layer.masksToBounds = false
        notificationDBTableView.layer.shadowColor = color.cgColor
        notificationDBTableView.layer.shadowOpacity = opacity
        notificationDBTableView.layer.shadowOffset = offSet
        notificationDBTableView.layer.shadowRadius = radius
        notificationDBTableView.layer.cornerRadius = 5.0
        notificationDBTableView.layer.shouldRasterize = true
        notificationDBTableView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func registerCustomCell()
    {
        self.notificationDBTableView.register(UINib(nibName: "DeliveryBoyNotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryBoyNotificationsTableViewCell")
    }

}
extension DeliveryBoyViewController: UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - UITableView Delegate and datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryBoyNotificationsTableViewCell") as! DeliveryBoyNotificationsTableViewCell
        cell.lblOrderStatus.text = notification[indexPath.row]["content"]["body"].stringValue
        cell.lblOrderTitle.text = notification[indexPath.row]["content"]["title"].stringValue
        cell.lblDate.text = OtherHelper.convertDateToString(date: notification[indexPath.row]["createdAt"].stringValue)
        if indexPath.row == self.notification.count - 1 && loadMore {
            loadMore = false
            getNotification()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            if indexPath.row >= (notification.count  ) && loadMore {
//                page += 1
//                loadMore = false
//                self.getNotification()
//            }
//    }
}

extension DeliveryBoyViewController{
    
    func getNotification() {
        NetworkHelper.get(url: Path.baseURL+"notification", param: ["userId": UserManager.getUserId(), "skip": notification.count], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            self.loadMore = true
            guard let json = json else {
                return
            }
            if let notifications = json["response"].array{
                for notification in notifications {
                    self.notification.append(notification)
                }
            }
            if self.notification.count == 0{
                self.loadMore = false
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.notificationDBTableView.reloadData()
            }
            print(self.notification.count)
        })
    }
    
}
