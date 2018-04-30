//
//  LandingViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 08/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON
import SDWebImage
import BBBadgeBarButtonItem

class LandingViewController: UIViewController {
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var hotspotCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var searchBar_ref: UISearchBar!
    @IBOutlet weak var searchController_ref: UISearchController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hotstarHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var itemCategoryLabel_ref: UILabel!
    @IBOutlet weak var hotStarLable_ref: UILabel!
    @IBOutlet weak var btnCart_ref: BBBadgeBarButtonItem!
    
    var categoryJson : [JSON] = []
    var itemJson : [JSON] = []
    var hotspotJson : [JSON] = []
    var bannerJson : [JSON] = []
    var searchController: UISearchController!
    var comingFrom:String! = "store"
    var selectedItemId:String! = ""
    var hotStarHeight : CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCostomization()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Colors.viewBackgroundColor
        let searchControllerViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchControllerViewController") as! SearchControllerViewController
        searchController = UISearchController(searchResultsController: searchControllerViewController)
        searchController.searchResultsUpdater = searchControllerViewController as UISearchResultsUpdating
        
        definesPresentationContext = true
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 60)
        searchController.searchBar.barTintColor = Colors.redBackgroundColor
        searchController.searchBar.tintColor = UIColor.black
        let searchTextField = searchController.searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.textColor = UIColor.black
        self.view.addSubview(searchController.searchBar)
        searchBar_ref.isHidden = true
        self.getDataFromServer()
        
        if !UserDefaults.standard.bool(forKey: AppConstant.isCurrentLocationSaved){
            self.performSegue(withIdentifier: "getLocationSegue", sender: nil)
        }
        btnCart_ref.badgeFont = UIFont.boldSystemFont(ofSize: 12)
        btnCart_ref.badgeValue = "2"
        btnCart_ref.badgeTextColor = UIColor.white
    }
    @IBAction func btnCart_Action(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showCartSegue", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let height = hotStarHeight{
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height + 320)
        }
    }
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        // SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func viewCostomization(){
        self.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.itemCollectionView.backgroundColor = Colors.viewBackgroundColor
        self.categoryCollectionView.backgroundColor = Colors.viewBackgroundColor
        self.hotspotCollectionView.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Server Action
    
    func getDataFromServer()  {
        NetworkHelper.get(url: Path.categoryURL, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.categoryJson = json["response"]["category"].arrayValue
            self.itemJson = json["response"]["itemcategory"].arrayValue
            self.hotspotJson = json["response"]["hotspot"].arrayValue
            self.bannerJson = json["response"]["banner"].arrayValue
            if self.itemJson.count > 0{
                self.itemCategoryLabel_ref.isHidden = false
            }else{
                self.itemCategoryLabel_ref.isHidden = true
            }
            if self.hotspotJson.count > 0{
                self.hotStarLable_ref.isHidden = false
            }else{
                self.hotStarLable_ref.isHidden = true
            }
            if self.bannerJson.count > 0{
                self.bannerView.isHidden = false
                 self.bannerView.sd_setImage(with: URL(string:Path.baseURL + self.bannerJson[0]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            }else{
                self.bannerView.isHidden = true
            }
            self.itemCollectionView.reloadData()
            self.categoryCollectionView.reloadData()
            self.hotspotCollectionView.reloadData()
            UserManager.setCategory(detail: json["response"]["category"])
            UserManager.setItemCategory(detail: json["response"]["itemcategory"])
            
            self.hotStarHeight = self.hotspotCollectionView.collectionViewLayout.collectionViewContentSize.height;
            if let height = self.hotStarHeight{
                self.hotstarHeightConstant.constant = height
                self.hotspotCollectionView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            }
            
            self.viewWillLayoutSubviews()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "HomeToListing" {
            if let viewController = segue.destination as? StorePointViewController {
                viewController.comingFrom = self.comingFrom
                viewController.selectedItemId = self.selectedItemId
            }
        }
    }
}
extension LandingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1001:
            return self.categoryJson.count
        case 1002:
            return self.itemJson.count
        case 1003:
            //return 30
            return self.hotspotJson.count
        default:
            return 0
        }
    }
    
    //3
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1001:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.itemImg.sd_setImage(with: URL(string:Path.baseURL + categoryJson[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            cell.itemImg.layer.cornerRadius = cell.itemImg.frame.size.width / 2
            cell.itemImg.clipsToBounds = true
            cell.itemImg.layer.borderWidth = 1.5
            cell.itemImg.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        case 1002:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.categoryImg.sd_setImage(with: URL(string:Path.baseURL + itemJson[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            
            cell.categoryImg.layer.cornerRadius = cell.categoryImg.frame.size.width / 2
            cell.categoryImg.clipsToBounds = true
            cell.categoryImg.layer.borderWidth = 1.5
            cell.categoryImg.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        case 1003:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotspotItemCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.buyNowBtn.layer.cornerRadius = 3.0
            cell.buyNowBtn.clipsToBounds = true
            cell.hotspotImg.sd_setImage(with: URL(string:Path.baseURL + hotspotJson[indexPath.row]["item"]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            cell.titleLbl.text = hotspotJson[indexPath.row]["item"]["item"].stringValue
            cell.memberLbl.text = hotspotJson[indexPath.row]["item"]["member"].stringValue + " Member"
            cell.messageLbl.text = hotspotJson[indexPath.row]["item"]["commentsCount"].stringValue
            cell.soldLbl.text = "Sold "+hotspotJson[indexPath.row]["item"]["sold"].stringValue
            cell.priceLbl.text = "$"+hotspotJson[indexPath.row]["price"].stringValue
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1001:
            self.comingFrom = "store"
            self.selectedItemId = categoryJson[indexPath.row]["_id"].stringValue
        case 1002:
            self.comingFrom = "category"
            self.selectedItemId = itemJson[indexPath.row]["_id"].stringValue
        case 1003:
            self.comingFrom = "hotsPot"
            self.selectedItemId = hotspotJson[indexPath.row]["_id"].stringValue
        default:
            break
        }
        self.performSegue(withIdentifier: "HomeToListing", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,5,0,5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1001:
            return CGSize(width: 78, height: 80)
        case 1002:
            return CGSize(width: 78, height: 80)
        case 1003:
            let padding: CGFloat =  0
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2-10, height: 107)
        default:
            break
        }
        return CGSize(width: 0, height: 0)
    }
}

extension LandingViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}

