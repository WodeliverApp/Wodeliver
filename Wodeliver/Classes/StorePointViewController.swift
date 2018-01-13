//
//  StorePointViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 09/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StorePointViewController: UIViewController {

    @IBOutlet weak var segmentView: MySegmentedControl!
    @IBOutlet weak var storepointTableView: UITableView!
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
        self.title = "Storepoint Listing"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
    }
    
    func registerCustomCell()
    {
        self.storepointTableView.register(UINib(nibName: "StorepointListingCell", bundle: nil), forCellReuseIdentifier: "StorepointListingCell")
    }
    @IBAction func segmentValueChnage(_ sender: Any) {
    }
    
}
extension StorePointViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorepointListingCell") as! StorepointListingCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StorepointListingCell.getCellHeight()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "orderNewToProfile", sender: nil)
    }
}
