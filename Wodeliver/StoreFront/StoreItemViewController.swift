//
//  StoreHistoryViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblHistory: UITableView!
    var storeItemList : [JSON] = []
    var itemCategory = UserManager.getItemCategory()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblHistory.register(UINib(nibName: "StoreHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreHistoryTableViewCell")
        self.viewCostomization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.getDataFromServer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDataFromServer()
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
    
    @IBAction func addButton_Action(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
        let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.present(viewController, animated: false, completion: nil)
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
        return self.storeItemList.count
    }
 
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreHistoryTableViewCell") as! StoreHistoryTableViewCell
        let item = self.storeItemList[indexPath.row]
        cell.lblProductName.text = item["item"].stringValue
        cell.lblProductPrice.text = "\("Price: ")\(item["price"].stringValue)"
      //  cell.lblProdcutCategory.text = item["item"].stringValue
        cell.lblDescription.text = "\("Description: ")\(item["description"].stringValue)"
        cell.imgProduct.sd_setImage(with: URL(string:Path.baseURL + item["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
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
            self.deleteStoreItem(itemId: self.storeItemList[indexPath.row]["_id"].stringValue, indexPath: indexPath)
            
        }
        delete.backgroundColor = Colors.redBackgroundColor
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            //self.isEditing = false
            let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
            let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
            viewController.itemObject = self.storeItemList[indexPath.row].dictionaryValue
            viewController.modalPresentationStyle = .overFullScreen
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
//            let animation = CATransition()
//            animation.duration = 1
//            animation.type = kCATransitionFade
//            self.view.window?.layer.add(animation, forKey: kCATransition)
//            
            self.present(viewController, animated: false, completion: nil)
        }
        edit.backgroundColor = UIColor.gray
        return [delete, edit]
    }

}

extension StoreItemViewController{
    //MARK: - Server Action
    
    func getDataFromServer()  {
        ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        let urlStr = Path.storeMenuItem+"storeId=\(UserManager.getStoreId())"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            ProgressBar.hideActivityIndicator(view: (self?.view)!)
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.storeItemList = json["response"].arrayValue
            print(self.storeItemList)
            self.tblHistory.reloadData()
        })
    }
    
    func deleteStoreItem(itemId : String, indexPath : IndexPath)  {
        
        NetworkHelper.post(url: Path.deleteItem + itemId , param: [:], self, completionHandler: {[weak self] json, error in
            ProgressBar.hideActivityIndicator(view: (self?.view)!)
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            self.storeItemList.remove(at: indexPath.row)
           self.tblHistory.reloadData()
        })
    }
}
