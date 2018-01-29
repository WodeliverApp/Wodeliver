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
class LandingViewController: UIViewController {
    
    
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var hotspotCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var searchBar_ref: UISearchBar!
    @IBOutlet weak var searchController_ref: UISearchController!
    var itemsArray  = ["cake","cake","cake","cake","cake"]
    var categoryArray = ["cloth","cloth","cloth","cloth","cloth"]
    var categoryJson : [JSON] = []
    var itemJson : [JSON] = []
    var hotspotJson : [JSON] = []
    var searchController: UISearchController!
    var comingFrom:String! = "store"
    var selectedItemId:String! = ""
    //    var hotspotItem = [HotspotItem]()
    //    var itemCategory = [ItemCategory]()
    //    var category = [CategoryItem]()
    // var banner = Banner(from: <#Decoder#>)
    
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
        //  ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.get(url: Path.categoryURL, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            //  ProgressBar.hideActivityIndicator(view: self.view)
            self.categoryJson = json["response"]["category"].arrayValue
            self.itemJson = json["response"]["itemcategory"].arrayValue
            self.hotspotJson = json["response"]["hotspot"].arrayValue
            self.itemCollectionView.reloadData()
            self.categoryCollectionView.reloadData()
            self.hotspotCollectionView.reloadData()
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
        case 1:
            return self.categoryJson.count
        case 2:
            return self.itemJson.count
        case 3:
            return self.hotspotJson.count
        //return self.hotspotArray.count
        default:
            return 0
        }
    }
    
    //3
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.itemImg.sd_setImage(with: URL(string:Path.baseURL + categoryJson[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            cell.itemImg.layer.cornerRadius = cell.itemImg.frame.size.width / 2
            cell.itemImg.clipsToBounds = true
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.categoryImg.sd_setImage(with: URL(string:Path.baseURL + itemJson[indexPath.row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            
            cell.categoryImg.layer.cornerRadius = cell.categoryImg.frame.size.width / 2
            cell.categoryImg.clipsToBounds = true
            return cell
        case 3:
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
        case 1:
            self.comingFrom = "store"
            self.selectedItemId = itemJson[indexPath.row]["_id"].stringValue
        case 2:
            self.comingFrom = "category"
            self.selectedItemId = categoryJson[indexPath.row]["_id"].stringValue
        case 2:
            self.comingFrom = "hotsPot"
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
        case 1:
            return CGSize(width: 78, height: 80)
        case 2:
            return CGSize(width: 78, height: 80)
        case 3:
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

