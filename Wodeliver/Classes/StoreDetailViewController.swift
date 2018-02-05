//
//  StoreDetailViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet weak var storeDetailTableView: UITableView!
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
        self.title = "Storepoint Detail"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.storeDetailTableView.layer.cornerRadius = 8.0
        self.storeDetailTableView.clipsToBounds = true
        self.navigationController?.navigationBar.topItem?.title = " "
        
    }
    
    func registerCustomCell()
    {
        self.storeDetailTableView.register(UINib(nibName: "StoreDetailCell", bundle: nil), forCellReuseIdentifier: "StoreDetailCell")
    }
    @IBAction func segmentValueChnage(_ sender: Any) {
    }
    
}
extension StoreDetailViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailCell") as! StoreDetailCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreDetailCell.getCellHeight()
    }
}
