//
//  NewOrderViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/22/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController {

    @IBOutlet weak var newOrderTableView: UITableView!
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
        self.title = "History"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
    }
    func registerCustomCell()
    {
        self.newOrderTableView.register(UINib(nibName: "HistoryHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryHeaderTableViewCell")
        self.newOrderTableView.register(UINib(nibName: "HistoryNewTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryNewTableViewCell")
    }
    
}
extension NewOrderViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
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
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryNewTableViewCell") as! HistoryNewTableViewCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HistoryNewTableViewCell.getCellHeight()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "orderNewToProfile", sender: nil)
    }
}
