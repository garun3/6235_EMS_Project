//
//  FilterSelectorVC.swift
//  EMS iOS App
//

import Foundation
import UIKit

protocol FilterSelectorDelegate: class {
    func onFilterSelected(_ appliedFilters: [FilterIH]?)
}

class FilterSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let counties: [String] = ["Appling", "Bacon", "Baldwin", "Barrow", "Bartow", "Ben Hill","Berrien", "Bibb", "Bleckley", "Brooks", "Bulloch", "Burke", "Butts", "Camden","Candler", "Carroll", "Catoosa", "Chatham", "Cherokee", "Clarke", "Clayton", "Clinch","Cobb", "Coffee", "Colquitt", "Cook", "Coweta", "Crisp", "DeKalb", "Decatur", "Dodge","Dougherty", "Douglas", "Early", "Effingham", "Elbert", "Emanuel", "Evans", "Fannin","Fayette", "Floyd", "Forsyth", "Franklin", "Fulton", "Glynn", "Gordon", "Grady","Greene", "Gwinnett", "Habersham", "Hall", "Haralson", "Henry", "Houston", "Irwin","Jasper", "Jeff Davis", "Jefferson", "Jenkins", "Lanier", "Laurens", "Liberty","Lowndes", "Lumpkin", "Macon", "McDuffie", "Meriwether", "Miller", "Mitchell", "Monroe","Morgan", "Murray", "Muscogee", "Newton", "Paulding", "Peach", "Pickens", "Polk","Pulaski", "Putnam", "Rabun", "Randolph", "Richmond", "Rockdale", "Screven", "Seminole","Spalding", "Stephens", "Sumter", "Tattnall", "Thomas", "Tift", "Toombs", "Towns","Troup", "Union", "Upson", "Walton", "Ware", "Washington", "Wayne", "Whitfield","Wilkes", "Worth"]
    
    var appliedFilters: Array<FilterIH>! = []
    var finalAppliedFilters: Array<FilterIH>! = []
    weak var delegate: FilterSelectorDelegate?
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet var specialtyCenterValues: UITableView!
    @IBOutlet var specialtyCenterButton: UIButton!
    @IBOutlet var specialtyCenterHeight: NSLayoutConstraint!
    
    @IBOutlet var emsRegionValues: UITableView!
    @IBOutlet var emsRegionButton: UIButton!
    @IBOutlet var emsRegionHeight: NSLayoutConstraint!
    
    @IBOutlet var countyValues: UITableView!
    @IBOutlet var countyButton: UIButton!
    @IBOutlet var countyHeight: NSLayoutConstraint!
    
    @IBOutlet var rchValues: UITableView!
    @IBOutlet var rchButton: UIButton!
    @IBOutlet var rchHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.specialtyCenterValues.delegate = self
        self.specialtyCenterValues.dataSource = self
        self.emsRegionValues.delegate = self
        self.emsRegionValues.dataSource = self
        self.countyValues.delegate = self
        self.countyValues.dataSource = self
        self.rchValues.delegate = self
        self.rchValues.dataSource = self
        
        finalAppliedFilters = []
        
        customizeButton(buttonName: self.specialtyCenterButton)
        customizeButton(buttonName: self.emsRegionButton)
        customizeButton(buttonName: self.countyButton)
        customizeButton(buttonName: self.rchButton)
    }
    
    func customizeButton(buttonName:UIButton) {
        buttonName.layer.borderWidth = 2
        buttonName.layer.borderColor = UIColor(rgb: 0x1B3CB1).cgColor
        buttonName.imageView?.contentMode = .scaleAspectFit
        buttonName.contentHorizontalAlignment = .right
        let availableWidth = buttonName.bounds.inset(by: buttonName.contentEdgeInsets).width - (buttonName.imageView?.frame.width ?? 0) - (buttonName.titleLabel?.frame.width ?? 0)
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
        buttonName.setImage(UIImage(named: "ArrowIcon"), for: .normal)
        buttonName.setImage(UIImage(named: "ArrowIconUp"), for: .selected)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
        delegate?.onFilterSelected(self.appliedFilters)
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        self.appliedFilters = []
        self.specialtyCenterValues.reloadData()
        self.emsRegionValues.reloadData()
        self.countyValues.reloadData()
        self.rchValues.reloadData()
    }
    
    @IBAction func expandCollapseField(_ sender: UIButton) {
        let allFields = [specialtyCenterValues, emsRegionValues, countyValues, rchValues]
        let allHeights = [specialtyCenterHeight, emsRegionHeight, countyHeight, rchHeight]
        let allButtons = [specialtyCenterButton, emsRegionButton, countyButton, rchButton]
        var selectedIndex = Int()
        
        switch sender {
        case specialtyCenterButton:
            selectedIndex = 0
        case emsRegionButton:
            selectedIndex = 1
        case countyButton:
            selectedIndex = 2
        case rchButton:
            selectedIndex = 3
        default:
            selectedIndex = -1
        }
        
        if selectedIndex != -1 {
            if allFields[selectedIndex]?.isHidden == true{
                for i in 0...3 {
                    if (i == selectedIndex) {
                        allFields[i]?.isHidden = false
                        allHeights[i]?.constant = 300
                        allButtons[i]?.isSelected = true
                    } else {
                        allFields[i]?.isHidden = true
                        allHeights[i]?.constant = 50
                        allButtons[i]?.isSelected = false
                    }
                }
                
            } else {
                allFields[selectedIndex]?.isHidden = true
                allHeights[selectedIndex]?.constant = 50
                allButtons[selectedIndex]?.isSelected = false
            }
        }
        
    }
    
    @objc
    func applyFilter(_ sender: FilterCheckBox) {
        if sender.isChecked {
            self.appliedFilters.append(FilterIH(field: sender.field, value: sender.value))
        } else {
            if let index = self.appliedFilters.firstIndex(where: {$0.field == sender.field && $0.value == sender.value}) {
                self.appliedFilters.remove(at: index)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == specialtyCenterValues {
            return HospitalType.allCases.count
        } else if tableView == emsRegionValues {
            return 10
        } else if tableView == countyValues {
            return counties.count
        } else if tableView == rchValues {
            return 14
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == specialtyCenterValues {
            let cell = specialtyCenterValues.dequeueReusableCell(withIdentifier: "specialtyCenterCheckListCell", for: indexPath) as! CheckListCell
            let specialtyCenter = HospitalType.allCases[indexPath.row].rawValue
            
            cell.checkBox.field = FilterType.type
            cell.checkBox.value = specialtyCenter
            cell.checkBox.addTarget(self, action: #selector(self.applyFilter(_:)), for: .touchUpInside)
            cell.checkBox.isChecked = (self.appliedFilters.firstIndex(where: {$0.field == FilterType.type && $0.value == specialtyCenter}) != nil)
            cell.checkListValueLabel.text = HospitalType(rawValue: specialtyCenter)!.getHospitalDisplayString()
        
            return cell
        } else if tableView == emsRegionValues {
            let cell = emsRegionValues.dequeueReusableCell(withIdentifier: "emsRegionCheckListCell", for: indexPath) as! CheckListCell
            let emsRegion = "\(indexPath.row + 1)"
            
            cell.checkBox.field = FilterType.emsRegion
            cell.checkBox.value = emsRegion
            cell.checkBox.addTarget(self, action: #selector(self.applyFilter(_:)), for: .touchUpInside)
            cell.checkBox.isChecked = (self.appliedFilters.firstIndex(where: {$0.field == FilterType.emsRegion && $0.value == emsRegion}) != nil)
            cell.checkListValueLabel.text = "Region " + emsRegion
        
            return cell
        } else if tableView == countyValues {
            let cell = countyValues.dequeueReusableCell(withIdentifier: "countyCheckListCell", for: indexPath) as! CheckListCell
            let county = counties[indexPath.row]
            
            cell.checkBox.field = FilterType.county
            cell.checkBox.value = county
            cell.checkBox.addTarget(self, action: #selector(self.applyFilter(_:)), for: .touchUpInside)
            cell.checkBox.isChecked = (self.appliedFilters.firstIndex(where: {$0.field == FilterType.county && $0.value == county}) != nil)
            cell.checkListValueLabel.text = county
        
            return cell
        } else if tableView == rchValues {
            let cell = rchValues.dequeueReusableCell(withIdentifier: "rchCheckListCell", for: indexPath) as! CheckListCell
            let rch = "\(Character(UnicodeScalar(indexPath.row + 65)!))"
            
            cell.checkBox.field = FilterType.rch
            cell.checkBox.value = rch
            cell.checkBox.addTarget(self, action: #selector(self.applyFilter(_:)), for: .touchUpInside)
            cell.checkBox.isChecked = (self.appliedFilters.firstIndex(where: {$0.field == FilterType.rch && $0.value == rch}) != nil)
            cell.checkListValueLabel.text = "Regional Coordinating Hospital " + rch
        
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(30)
    }
}
