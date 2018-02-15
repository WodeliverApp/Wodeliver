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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.searchTableView.register(UINib(nibName: "SearchByItemCell", bundle: nil), forCellReuseIdentifier: "SearchByItemCell")
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchControllerCell")
        
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
            NetworkHelper.stopAllSessions()
            searchByText = searchText
//            page = 0
//            isSearching = true
//            searchExploreUser = []
//            tableView.reloadData()
//            tableView.backgroundView?.isHidden = true
            if searchByText.count > 0 {
                generateRequest()
            }
        }
    }
    
    // MARK: - Get User List From Server
    
    func generateRequest() {
    
        let param:[String:Any] = ["text":searchByText,"&searchOn":0]
        getResponse(param)
    }
    
    func getResponse(_ param:[String:Any]){
        NetworkHelper.get(url: Path.searchURL, param: param, self, completionHandler: {[weak self] json, error in
            guard self != nil else { return }
            guard let json = json else {
                return
            }
//            self.loadMore = true
//            self.isSearching = false
         
                if let searchData = json["data"].array {
                    print(searchData)
                    if searchData.count > 0 {
//                        if self.page == 0 {
//                            self.searchExploreUser = []
//                            self.perform(#selector(self.sendSearchEvent(sender:)), with: param["query"], afterDelay: 2.0)
//                        }
//                        for item in exploreUser {
//                            let storedUser = ExploreUser()
//                            storedUser.user = try self.saveUser(user: item)
//                            self.searchExploreUser.append(storedUser)
//                        }
//                    }else {
//                        if self.page == 0 {
//                            self.tableView.backgroundView?.isHidden = false
//                        }
//                        self.loadMore = false
//                    }
//                }
              // self.searchTableView.reloadData()
                //try self.appDelegate.mainThreadFeedManagedObjectContext.save()
            
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
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchControllerCell") as UITableViewCell!

        cell.textLabel?.text = "Demo Data"
        cell.textLabel?.textColor = UIColor.gray
            return cell
       
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
    }
}
