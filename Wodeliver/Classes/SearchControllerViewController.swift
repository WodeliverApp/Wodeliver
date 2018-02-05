//
//  SearchControllerViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class SearchControllerViewController: UIViewController ,UISearchBarDelegate, UISearchDisplayDelegate,UISearchResultsUpdating{

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var segmentView: MySegmentedControl!
    var isItem:Bool! = true
    var searchByText = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchTableView.register(UINib(nibName: "SearchByItemCell", bundle: nil), forCellReuseIdentifier: "SearchByItemCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentView.selectedSegmentIndex = 0
        self.segmentView.addTarget(self, action: #selector(changeSegmentValue(sender:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeSegmentValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isItem = true
        case 1:
            isItem = false
        default: break
        }
        self.searchTableView.reloadData()
    }
    
    // MARK: - UISearchController Delegate and Data Source
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchByText != searchText {
            NetworkHelper.stopAllSessions()
//            searchByText = searchText
//            page = 0
//            isSearching = true
//            searchExploreUser = []
//            tableView.reloadData()
//            tableView.backgroundView?.isHidden = true
//            if searchByText.count > 0 {
//                generateRequest()
//            }
        }
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
        if isItem{
            return 5
        }else{
            return 5
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isItem{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchByItemCell") as! SearchByItemCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchByItemCell") as! SearchByItemCell
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isItem{
            return SearchByItemCell.getCellHeight()
        }else{
            return SearchByItemCell.getCellHeight()
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isItem{
        }else{
           // self.performSegue(withIdentifier: "storeListToDetail", sender: nil)
        }
    }
}
