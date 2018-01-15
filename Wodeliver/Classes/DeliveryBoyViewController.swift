//
//  DeliveryBoyViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 15/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class DeliveryBoyViewController: UIViewController {

    
     @IBOutlet weak var notificationDBTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.registerCustomCell()
    }
    
    func registerCustomCell()
    {
        self.notificationDBTableView.register(UINib(nibName: "StoreNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreNotificationTableViewCell")
    }

}
extension DeliveryBoyViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreNotificationTableViewCell") as! StoreNotificationTableViewCell
        if Int(indexPath.row )%2 == 0 {
            cell._ImagePRofile.layer.borderColor = Colors.redBackgroundColor.cgColor
            cell._ImagePRofile.clipsToBounds = true
            cell._ImagePRofile.layer.cornerRadius = 2.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreHistoryTableViewCell.getCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
