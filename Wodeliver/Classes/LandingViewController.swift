//
//  LandingViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 08/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SideMenu
class LandingViewController: UIViewController {

    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var hotspotCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: UIImageView!
    
    var itemsArray  = ["cake","cake","cake","cake","cake"]
    var categoryArray = ["cloth","cloth","cloth","cloth","cloth"]
   // var hotspotArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.viewCostomization()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Colors.viewBackgroundColor
        
//        NetworkHelper.get(url: Path.categoryURL, param: [:], self, completionHandler: {[weak self] json, error in
//            guard let `self` = self else { return }
//           print(json)
//            print(error)
//            guard (json != nil) else {
//                // self.finishProcess()
//                return
//            }
//        })
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
    
}
extension LandingViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
              return 1
    }
    
    //2
    public func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return self.itemsArray.count
        case 2:
            return self.categoryArray.count
        case 3:
            return 4
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
        cell.itemImg.image = UIImage.init(named: itemsArray[indexPath.row])
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.categoryImg.image = UIImage.init(named: categoryArray[indexPath.row])
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotspotItemCell",
                                                          for: indexPath) as! landingScreenCollectionViewCell
            cell.buyNowBtn.layer.cornerRadius = 3.0
            cell.buyNowBtn.clipsToBounds = true
            return cell
        default:
            return UICollectionViewCell()
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
          break
        case 2:
           break
        case 3:
            let padding: CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
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

