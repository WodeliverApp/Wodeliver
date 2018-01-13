//
//  LandingViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 08/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

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
