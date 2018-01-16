//
//  TracingViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/22/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class TracingViewController: UIViewController {

    @IBOutlet weak var orderStatusTableView: UITableView!
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
        self.title = "Tracing"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
    }
    func registerCustomCell()
    {
        self.orderStatusTableView.register(UINib(nibName: "CurrentStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentStatusTableViewCell")
    }
    
}
extension TracingViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentStatusTableViewCell") as! CurrentStatusTableViewCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CurrentStatusTableViewCell.getCellHeight()
    }
}

