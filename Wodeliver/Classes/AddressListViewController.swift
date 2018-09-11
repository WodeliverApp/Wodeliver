//
//  AddressListViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/06/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressListViewController: UIViewController {

    @IBOutlet weak var tblAddressList: UITableView!
    var addressList : [JSON] = []
    var selectedAddress : JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCustomCell()
        viewCostomization()
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addAddress))
        self.navigationItem.rightBarButtonItem = addButton
        tblAddressList.allowsMultipleSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddressList()
    }
    
    @objc func addAddress(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addAddressSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func viewCostomization(){
        self.title = "Address List"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = Colors.redBackgroundColor
    }
    
    func registerCustomCell()
    {
        self.tblAddressList.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
    }

    
    func getAddressList() {
        let urlStr = Path.addressList+"\(UserManager.getUserId())"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            print(json)
            self.addressList = json["response"].arrayValue
            if self.addressList.count == 0{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.tblAddressList.reloadData()
            }
        })
    }
    
    @objc func editButton_ref(sender: UIButton) {
        
    }
    
    @IBAction func btnDeliveryHere_Action(_ sender: UIButton) {
        if selectedAddress == nil{
            OtherHelper.simpleDialog("Error", "Please select atleast one delivery address", self)
            return
        }
        UserDefaults.standard.set(selectedAddress!.rawString(), forKey: AppConstant.userSelectedAddress)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

extension AddressListViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addressList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        cell.lblAddress.text = addressList[indexPath.row]["address"].stringValue
        cell.lblUserName.text = UserManager.getUserDetail()["name"].stringValue
//        cell.btnEdit_ref.addTarget(self, action: #selector(editButton_ref), for: .touchUpInside)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddressTableViewCell.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark{
            cell.accessoryType = .none
            selectedAddress = nil
        }else{
            cell.accessoryType = .checkmark
            selectedAddress = addressList[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        selectedAddress = nil
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

            let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
               // self.deleteStoreItem(itemId: self.storeItemList[indexPath.row]["_id"].stringValue, indexPath: indexPath)
                
            }
            delete.backgroundColor = Colors.redBackgroundColor
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
//                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
//                let viewController : AddItemViewController = storyboard.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
//                viewController.itemObject = self.storeItemList[indexPath.row].dictionaryValue
//                viewController.modalPresentationStyle = .overFullScreen
//                viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//                self.present(viewController, animated: false, completion: nil)
            }
            edit.backgroundColor = UIColor.gray
            return [delete, edit]
        
        // return nil
    }
}
