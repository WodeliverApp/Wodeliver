//
//  StoreHomeTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import ExpyTableView

class StoreHomeTableViewCell: UITableViewCell, ExpyTableViewHeaderCell {

    @IBOutlet weak var lblHeaderName: UILabel!
    @IBOutlet weak var imageViewArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblHeaderName.layer.cornerRadius = 3.0
        lblHeaderName.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            hideSeparator()
            arrowDown(animated: !cellReuse)
            
        case .willCollapse:
            print("WILL COLLAPSE")
            arrowRight(animated: !cellReuse)
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            showSeparator()
            print("DID COLLAPSE")
        }
    }
    
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) { [weak self]  in
           // self?.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
            self?.imageViewArrow.image = UIImage.init(named: "icon_discard")
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) { [weak self] in
          //  self?.imageViewArrow.transform = CGAffineTransform(rotationAngle: 0)
             self?.imageViewArrow.image = UIImage.init(named: "icon_plus")
        }
    }
    
}
class HomeListingTableViewCell: UITableViewCell {
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class TotalOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
}

class AgentConfirmCell: UITableViewCell {
    @IBOutlet weak var txtAgent: UITextField!
    
    @IBOutlet weak var btnConfirm_ref: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnConfirm_ref.layer.cornerRadius = 5.0
        btnConfirm_ref.clipsToBounds = true
    }
}
extension UITableViewCell {
    
    func showSeparator() {
        DispatchQueue.main.async { [weak self]  in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        }
    }
}
