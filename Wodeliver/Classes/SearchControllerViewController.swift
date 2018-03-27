//
//  SearchControllerViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchControllerViewController: UIViewController ,UISearchBarDelegate, UISearchDisplayDelegate,UISearchResultsUpdating{
    
    @IBOutlet weak var searchTableView: UITableView!
    var isItem:Bool! = true
    var searchByText = ""
    var searchItem : [JSON] = []
    var filteredArray : [JSON] = []
    var isActiveSearch : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchControllerCell")
         self.generateRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchController Delegate and Data Source
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchByText != searchText {
            searchByText = searchText
            if searchText.count > 0 {
                isActiveSearch = true
                filteredArray = searchItem.filter { $0["name"].stringValue.contains(searchText) }
                searchTableView.reloadData()
            }else{
                isActiveSearch = false
            }
        }
    }
    
    // MARK: - Get User List From Server
    
    func generateRequest() {
        let param:[String:Any] = [:]
        getResponse(param)
    }
    
    func getResponse(_ param:[String:Any]){
        NetworkHelper.stopAllSessions()
        NetworkHelper.get(url: Path.searchURL, param: param, self, completionHandler: {[weak self] json, error in
            guard self != nil else { return }
            guard let json = json else {
                return
            }
            if let searchData = json["response"].array {
                if searchData.count > 0 {
                    self?.searchItem = searchData
                }
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
extension SearchControllerViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - UITableView Delegate and datasource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isActiveSearch{
            return filteredArray.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchControllerCell") as UITableViewCell!
        cell.textLabel?.text = filteredArray[indexPath.row]["name"].stringValue
        cell.textLabel?.textColor = UIColor.gray
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(filteredArray[indexPath.row])
//       self.performSegue(withIdentifier: "storeListToDetail", sender: nil)
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
//        let navigationController1 = UINavigationController(rootViewController: vc)
//        navigationController?.pushViewController(navigationController1, animated: true)
       // self.present(navigationController, animated: true, completion: nil)
    }
}
