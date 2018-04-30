//
//  RemaksViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 03/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class RemaksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var remarksTableView: UITableView!
    var commentList : [JSON] = []
    var entityId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  entityId = "5a38069dccec263d205cdb54"
        self.viewCustomization()
        self.remarksTableView.register(UINib(nibName: "RemarkCell", bundle: nil), forCellReuseIdentifier: "RemarkCell")
        self.remarksTableView.delegate = self
        self.remarksTableView.dataSource = self
        self.getCommentFromSevver(pageNumber: "0")
        remarksTableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewCustomization(){
        self.title = "Remarks"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func getCommentFromSevver(pageNumber : String) {
        let urlStr = Path.commentList+entityId+"&skip=\(pageNumber)"
        NetworkHelper.get(url: urlStr, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.commentList = json["response"].arrayValue
            if self.commentList.count == 0{
                OtherHelper.simpleDialog("Error", "No record found.", self)
            }else{
                self.remarksTableView.reloadData()
            }
        })
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
extension RemaksViewController{
    // MARK: - UITableView Delegate and datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkCell") as! RemarkCell
        if Int(indexPath.row )%2 == 0 {
//            cell.menuImageView.layer.borderColor = Colors.redBackgroundColor.cgColor
//            cell.menuImageView.clipsToBounds = true
//            cell.menuImageView.layer.cornerRadius = 2.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuTableViewCell.getCellHeight()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
