//
//  StoreHistoryViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblHistory.register(UINib(nibName: "StoreHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreHistoryTableViewCell")
        self.viewCostomization()
    }

    func viewCostomization(){
        self.title = "Store Management"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegate and datasource Methods
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
 
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreHistoryTableViewCell") as! StoreHistoryTableViewCell
       // cell.lblHeaderName
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreHistoryTableViewCell.getCellHeight()
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
