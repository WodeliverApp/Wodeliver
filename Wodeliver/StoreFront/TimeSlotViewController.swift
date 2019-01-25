//
//  TimeSlotViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol TimeSlotProtocol {
    func setTimeSlots(selectedIds : [String], selectedTimes : [String], selectedIdsInt : [Int]) // this function the first controllers
}

class TimeSlotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnDone_ref: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnClose_ref: UIButton!
    @IBOutlet weak var timeTableView: UITableView!
    var delegate: TimeSlotProtocol?
    var timeSlot : [JSON] = []
    var isHotSpotItem : Bool = false
    var selectedIds = [String]()
    var selectedTimes = [String]()
    var selectedIdsInt = [Int]()
    var startDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 5.0
        backView.layer.borderWidth = 1.0
        backView.clipsToBounds = true
        self.timeTableView.allowsMultipleSelection = true
        if isHotSpotItem{
            let param = ["slotFor":"2", "date":OtherHelper.getISOString(date: startDate)] as [String : Any]
            self.getAvailableTimeSlot(param: param)
        }else{
            let param = ["slotFor":"1", "date":OtherHelper.getISOString(date: startDate)] as [String : Any]
            self.getAvailableTimeSlot(param: param)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Actions
    
    @IBAction func btnClose_Action(_ sender: UIButton) {
        delegate?.setTimeSlots(selectedIds: selectedIds, selectedTimes: selectedTimes, selectedIdsInt: selectedIdsInt)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone_Action(_ sender: UIButton) {
        delegate?.setTimeSlots(selectedIds: selectedIds, selectedTimes: selectedTimes, selectedIdsInt: selectedIdsInt)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableView Delegate and datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return timeSlot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTableViewCell", for: indexPath) as! TimeSlotTableViewCell
        cell.lblSlotItem.text = self.timeSlot[indexPath.row]["slot"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        if !selectedIds.contains(timeSlot[indexPath.row]["id"].stringValue){
            selectedIds.append(timeSlot[indexPath.row]["id"].stringValue)
            selectedTimes.append(timeSlot[indexPath.row]["slot"].stringValue)
            selectedIdsInt.append(timeSlot[indexPath.row]["slot"].intValue)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        for i in 0..<selectedIds.count {
            if selectedIds[i] == self.timeSlot[indexPath.row]["id"].stringValue{
                selectedIds.remove(at: i)
                selectedTimes.remove(at: i)
                selectedIdsInt.remove(at: i)
                break
            }
        }
    }
    
    //MARK:- Server Action
    
    func getAvailableTimeSlot(param : [String : Any]){
        NetworkHelper.post(url: Path.getTimeSlot, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            self.timeSlot = json!["response"].arrayValue
            self.timeTableView.reloadData()
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
