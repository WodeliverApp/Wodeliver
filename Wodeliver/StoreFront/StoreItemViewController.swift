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
        self.tblHistory.backgroundColor = Colors.viewBackgroundColor
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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //self.isEditing = false
            print("more button tapped")
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            //self.isEditing = false
            let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
            let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
            viewController.modalPresentationStyle = .overFullScreen
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
//            let animation = CATransition()
//            animation.duration = 1
//            animation.type = kCATransitionFade
//            self.view.window?.layer.add(animation, forKey: kCATransition)
//            
            self.present(viewController, animated: false, completion: nil)
        }
        edit.backgroundColor = UIColor.red
        return [delete, edit]
    }

}
