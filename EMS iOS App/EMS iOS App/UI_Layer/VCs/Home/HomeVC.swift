//
//  HomeVC.swift
//  EMS iOS App
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, FilterSelectorDelegate, UISearchBarDelegate, SortSelectorDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var appliedFiltersView: UIStackView!
    @IBOutlet var clearAllFiltersButton: UIButton!
    @IBOutlet var bottomBarScrollView: UIScrollView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchBarHeight : NSLayoutConstraint!
    
    var hospitals: Array<HospitalIH>!
    var pinnedList: Array<HospitalIH>!
    var showingList: Array<HospitalIH>!
    var searchActive : Bool = false
    var appliedSort: SortType?
    var appliedFilters: Array<FilterIH>!
    var isMostApplicableView: Bool = false
    var recommender: RecommendationIH?
    
    var popupHandler = MenuPopupHandler()
    var sortSelectorView = SortSelectorView()
    let sortSelectorViewHeight: CGFloat = 208
    var filterCards: NSMutableArray!
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    let GCC_NUMBER = "4046166440"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.searchBar.isHidden = true
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.pinnedList = Array<HospitalIH>()
        self.appliedFilters = Array<FilterIH>()
                
        // swipe to refresh data
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(buildHospitalList), for: .valueChanged)
        
        // set up listener to reload hospital list when app re-enters foreground
        NotificationCenter.default.addObserver(self, selector: #selector(buildHospitalList), name: UIApplication.willEnterForegroundNotification, object: nil)
        if appliedSort == nil {
            self.appliedSort = SortType.defaultSort
        }
        sortSelectorView.setIsMostApplicableView(isMostApplicableView: self.isMostApplicableView)
        switch appliedSort {
        case .az:
            sortSelectorView.nameSort.backgroundColor = UIColor(named: "MainColorHighlight")
        case .distance:
            sortSelectorView.distanceSort.backgroundColor = UIColor(named: "MainColorHighlight")
        case .nedocs:
            sortSelectorView.nedocsSort.backgroundColor = UIColor(named: "MainColorHighlight")
        case .defaultSort:
            sortSelectorView.defaultSort.backgroundColor = UIColor(named: "MainColorHighlight")
        default:
            print("Error")
        }
        self.showingList = self.hospitals
        self.handleListChange()
        self.tableView.reloadData()
    }
    
    func showSearchBar() {
        self.searchBar.isHidden = false
        self.searchBarHeight.constant = 56
        self.searchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
             self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideSearchBar() {
        self.searchBar.resignFirstResponder()
        self.searchBarHeight.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.searchBar.isHidden = true
        })
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if !self.searchBar.isHidden && self.searchBar.searchTextField.text!.isEmpty {
            self.hideSearchBar()
        } else if self.searchBar.isHidden {
            self.showSearchBar()
        } else {
            self.searchBar.searchTextField.resignFirstResponder()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = nil
        self.hideSearchBar()
        searchActive = false
        self.showingList = self.hospitals
        self.handleListChange()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        if self.searchBar.searchTextField.text!.isEmpty {
            self.hideSearchBar()
        } else {
            self.searchBar.searchTextField.resignFirstResponder()
        }
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
            tableView.reloadData()
        } else {
            searchActive = true
            self.showingList = self.hospitals.filter({ (hos) -> Bool in
                let tmp: String = hos.name
                return tmp.range(of: searchText, options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
        
    }

    // helper method to build Hospital List from data
    @objc func buildHospitalList() {
        let tasker = HospitalsTasker()
        tasker.getAllHospitals(failure: {
            print("Failure")
        }, success: { (hospitals) in
            guard let hospitals = hospitals else {
                self.hospitals = Array<HospitalIH>()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            
            tasker.getHospitalDistances(hospitals: hospitals, finished: { (hospitals) in
                guard let hospitals = hospitals else {
                    self.hospitals = Array<HospitalIH>()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                    }
                    return
                }
                // Retrieve pinned hospitals in new list
                var newPinned = [HospitalIH]()
                for pinned in self.pinnedList {
                    for hospital in hospitals {
                        if (hospital.name == pinned.name) {
                            newPinned.append(hospital)
                        }
                    }
                }
                // Repin hospitals
                for pinned in newPinned {
                    if let index = hospitals.firstIndex(of: pinned) {
                        self.hospitals.remove(at: index)
                    }
                    self.hospitals.insert(pinned, at: 0)
                    pinned.isFavorite = true
                }
                self.pinnedList = newPinned
                self.hospitals = hospitals
                if self.isMostApplicableView && self.recommender != nil {
                    self.hospitals = self.recommender?.getHospitalRecommendations(hospitals: self.hospitals)
                }
                self.showingList = self.hospitals
                self.handleListChange()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (hospitals == nil) {
            return -1
        }
        return self.showingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var hospital: HospitalIH
        let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as! HomeTableViewCell
        
        hospital = self.showingList[indexPath.row]
        
        cell.hospitalName.text = hospital.name
        if (hospital.isFavorite) {
            cell.favoritePin.setImage(UIImage(named: "FilledFavoritePin"), for: .normal)
        } else {
            cell.favoritePin.setImage(UIImage(named: "OutlineFavoritePin"), for: .normal)
        }
        cell.nedocsView.layer.cornerRadius = 5.0
        cell.nedocsView.backgroundColor = hospital.nedocsScore.getNedocsColor()
        cell.nedocsLabel.text = hospital.nedocsScore.rawValue
        if (hospital.nedocsScore == NedocsScore(rawValue: "Overcrowded")) {
            cell.nedocsLabel.font = cell.nedocsLabel.font.withSize(11)
        } else {
            cell.nedocsLabel.font = cell.nedocsLabel.font.withSize(16)
        }
        if (hospital.hasDiversion) {
            // show diversion icon when diversion
            cell.diversionIcon?.isHidden = false
            cell.diversionIconWidth.constant = 25
            cell.diversionIconLeading.constant = 10
            
            // show expanded info about diversion when diversion
            cell.diversionsHolder.isHidden = false
            cell.expandedDiversionIconLabel.isHidden = false

            let currDiversionIcon: UIImage?
            switch hospital.diversions.count {
            case 1:
                currDiversionIcon = UIImage(named: "Warning1Icon")
            case 2:
                currDiversionIcon = UIImage(named: "Warning2Icon")
            case 3:
                currDiversionIcon = UIImage(named: "Warning3Icon")
            case 4:
                currDiversionIcon = UIImage(named: "Warning4Icon")
            case 5:
                currDiversionIcon = UIImage(named: "Warning5Icon")
            case 6:
                currDiversionIcon = UIImage(named: "Warning6Icon")
            default:
                currDiversionIcon = UIImage(named: "WarningIcon")
            }
            cell.diversionIcon?.image = currDiversionIcon
            cell.expandedDiversionIcon?.image = currDiversionIcon
            cell.expandedDiversionIconLabel.text = ""
            for i in 0...(hospital.diversions.count - 1) {
                if (i != hospital.diversions.count - 1) {
                    cell.expandedDiversionIconLabel.text! += hospital.diversions[i] + "\n"
                } else {
                    cell.expandedDiversionIconLabel.text! += hospital.diversions[i]
                }
            }
            
        } else {
            // hide diversion icon when no diversion
            cell.diversionIcon?.isHidden = true
            cell.diversionIconWidth.constant = 0
            cell.diversionIconLeading.constant = 0
            
            // hide expanded info about diversion when no diversion
            cell.diversionsHolder.isHidden = true
            cell.expandedDiversionIconLabel.isHidden = true
        }
        
        // default hide all hospital types
        cell.hospitalTypeIcon1.isHidden = true
        cell.hospitalTypeIcon2.isHidden = true
        cell.hospitalTypeIcon3.isHidden = true
        cell.hospitalTypeHolder1.isHidden = true
        cell.hospitalTypeHolder2.isHidden = true
        cell.hospitalTypeHolder3.isHidden = true

        if (hospital.specialtyCenters.count != 0) {
            for i in 0...(hospital.specialtyCenters.count - 1) {
                var currHospitalTypeIcon: UIImageView? = nil
                var currHospitalTypeHolder: UIStackView? = nil
                var currExpandedHospitalTypeIcon: UIImageView? = nil
                var currHospitalTypeLabel: UILabel? = nil

                switch i {
                case 0:
                    currHospitalTypeIcon = cell.hospitalTypeIcon1
                    currHospitalTypeHolder = cell.hospitalTypeHolder1
                    currExpandedHospitalTypeIcon = cell.expandedHospitalTypeIcon1
                    currHospitalTypeLabel = cell.hospitalTypeLabel1
                case 1:
                    currHospitalTypeIcon = cell.hospitalTypeIcon2
                    currHospitalTypeHolder = cell.hospitalTypeHolder2
                    currExpandedHospitalTypeIcon = cell.expandedHospitalTypeIcon2
                    currHospitalTypeLabel = cell.hospitalTypeLabel2
                case 2:
                    currHospitalTypeIcon = cell.hospitalTypeIcon3
                    currHospitalTypeHolder = cell.hospitalTypeHolder3
                    currExpandedHospitalTypeIcon = cell.expandedHospitalTypeIcon3
                    currHospitalTypeLabel = cell.hospitalTypeLabel3
                default:
                    break
                }
                
                if (currHospitalTypeIcon != nil && currExpandedHospitalTypeIcon != nil && currHospitalTypeLabel != nil) {
                    // unhide hospital type icon
                    currHospitalTypeIcon?.isHidden = false
                    
                    // unhide expanded info about hospital type
                    currHospitalTypeHolder?.isHidden = false
                    
                    currHospitalTypeIcon?.image = hospital.specialtyCenters[i].getHospitalIcon()
                    currExpandedHospitalTypeIcon?.image = hospital.specialtyCenters[i].getHospitalIcon()
                    currHospitalTypeLabel?.text = hospital.specialtyCenters[i].getHospitalDisplayString()
                }
            }
        }
        
        if (hospital.distance == -1.0) {
            cell.distanceLabel.text = "-- mi"
        } else {
            cell.distanceLabel.text = "\(String(hospital.distance)) mi"
        }
        
        cell.address.titleLabel!.numberOfLines = 2
        cell.address.setTitle(hospital.address, for: .normal)
        cell.address.setAttributedTitle(NSAttributedString(string: hospital.address, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        cell.address.setTitleColor(.blue, for: .normal)
        cell.address.addTarget(self, action: #selector(mapToHospital(_:)), for: .touchUpInside)
        
        let formattedPhone = self.applyPatternOnNumbers(number: hospital.phoneNumber, pattern: "(###) ###-####", replacementCharacter: "#")
        cell.phoneNumber.setTitle(formattedPhone, for: .normal)
        cell.phoneNumber.setAttributedTitle(NSAttributedString(string: formattedPhone, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        cell.phoneNumber.setTitleColor(.blue, for: .normal)
        cell.phoneNumber.addTarget(self, action: #selector(callHospital(_:)), for: .touchUpInside)
        cell.phoneIcon.addTarget(self, action: #selector(callHospital(_:)), for: .touchUpInside)
        cell.countyLabel.text = "\(String(hospital.county)) County - EMS Region \(String(hospital.regionNumber))"
        cell.rchLabel.text = "Regional Coordination Hospital \(String(hospital.rch))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss aa"
        let formattedLastUpdated = dateFormatter.string(from: hospital.lastUpdated)
        cell.lastUpdatedLabel.text = "Updated \(String(formattedLastUpdated))"
    
        return cell
    }
    
    func applyPatternOnNumbers(number: String, pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            var hospital:HospitalIH
            hospital = self.showingList[indexPath.row]
            if hospital.hasDiversion {
                // calculate the height of the expanded cell based on the number of diversions and hospital types
                return CGFloat(192 + 28 * (hospital.specialtyCenters.count) + (10 * (hospital.diversions.count - 1)))
            } else {
                // calculate the height of the expanded cell based on the number of hospital types
                return CGFloat(167 + 28 * hospital.specialtyCenters.count)
            }
        }
        return 90
    }
    
    func callPhoneNumber(number: String) {
        if Platform.isSimulator {
            let formattedNum = self.applyPatternOnNumbers(number: number, pattern: "(###) ###-####", replacementCharacter: "#")
            let warningMessage = UIAlertController(title: "Error", message: "You cannot make phone calls from a simulator. The number dialed was \(formattedNum).", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            warningMessage.addAction(okBtn)
            self.present(warningMessage, animated: true, completion: nil)
            return
        }
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func callGCC(_ sender: UIButton) {
        self.callPhoneNumber(number: self.GCC_NUMBER)
    }
    
    @IBAction func goToRecommendation(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRecommendations", sender: self)
    }
    
    @objc func callHospital(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview?.superview as? HomeTableViewCell else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        var hospital: HospitalIH!
        hospital = self.showingList[indexPath.row]
        guard let number = hospital.phoneNumber else {
            return
        }
        self.callPhoneNumber(number: number)
    }
    
    @objc func mapToHospital(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? HomeTableViewCell else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        var hospital: HospitalIH!
        hospital = self.showingList[indexPath.row]
        guard var address = hospital.address else {
            return
        }
        address = address.lowercased().replacingOccurrences(of: " ", with: "+")
        let urlStr = "http://maps.apple.com/?address=\(address)"
        guard let url =  URL(string: urlStr) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func expandButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? HomeTableViewCell else {
            return
        }

        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        cell.expandButton.isHidden = true
        cell.minimizeButton.isHidden = false
        
        if self.selectedRowIndex != -1 {
            self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath)?.backgroundColor = UIColor.white
            guard let prevCell = self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath) as? HomeTableViewCell else {
                return
            }
            prevCell.expandButton.setImage(UIImage(named:"ArrowIcon"), for: .normal)
            
        }

        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
            cell.expandButton.setImage(UIImage(named:"ArrowIconUp"), for: .normal)
        } else {
            cell.minimizeButton.isHidden = true
            cell.expandButton.isHidden = false
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
            cell.expandButton.setImage(UIImage(named:"ArrowIcon"), for: .normal)
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    @IBAction func favoritePin(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? HomeTableViewCell else {
            return
        }

        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        guard var newIndexPath = tableView.indexPath(for: cell) else {
            return
        }
        if (pinnedList.isEmpty) {
            newIndexPath = IndexPath(item: 0, section: 0)
        } else {
            newIndexPath = IndexPath(item: pinnedList.count, section: 0)
        }
            
        var pinnedHospital : HospitalIH
        
        pinnedHospital = self.showingList[indexPath.row]
        if (!pinnedHospital.isFavorite) {
            let myImage = UIImage(named: "FilledFavoritePin")
            cell.favoritePin.setImage(myImage, for: .normal)
            self.pinnedList.append(pinnedHospital)
            self.showingList.remove(at: indexPath.row)
            self.showingList.insert(pinnedHospital, at: 0)
            self.tableView.moveRow(at: indexPath, to: IndexPath(item: 0, section: 0))
            pinnedHospital.isFavorite = true
        } else {
            let myImage = UIImage(named: "OutlineFavoritePin")
            cell.favoritePin.setImage(myImage, for: .normal)
            guard let pinIndex = pinnedList.firstIndex(of: pinnedHospital) else {
                return
            }
            pinnedList.remove(at: pinIndex)
            guard let showIndex = self.showingList.firstIndex(of: pinnedHospital) else {
                return
            }
            self.showingList.remove(at: showIndex)
            self.showingList.insert(pinnedHospital, at: pinnedList.count + 1)
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
            pinnedHospital.isFavorite = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func handlePins() {
        var ind = 0
        for pinnedHospital in self.pinnedList {
            if let showingIndex = self.showingList.firstIndex(of: pinnedHospital) {
                self.showingList.remove(at: showingIndex)
                self.showingList.insert(pinnedHospital, at: ind)
            } else {
                if let hospIndex = self.hospitals.firstIndex(of: pinnedHospital) {
                    if hospIndex < self.showingList.count && self.showingList[hospIndex].name == pinnedHospital.name {
                        self.showingList.remove(at: hospIndex)
                    }
                }
                self.showingList.insert(pinnedHospital, at: ind)
            }
            
            ind += 1
        }
    }
    
    // sends data to FilterSelectorViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FilterSelectorViewController {
            let vc = segue.destination as? FilterSelectorViewController
            vc?.delegate = self
            vc?.appliedFilters = appliedFilters
        }
        if segue.identifier == "goToRecommendations" {
            let navVC = segue.destination as! UINavigationController
            let recVC = navVC.viewControllers.first as! RecommendVC
            recVC.hospitals = self.hospitals
        }
    }
    
    // callback when new filter is applied
    func onFilterSelected(_ appliedFilters: [FilterIH]?) {
        self.appliedFilters = appliedFilters
        
        // Hide Clear All button if there are no filters applied
        if appliedFilters!.count > 0 {
            self.clearAllFiltersButton.setTitle("Clear All", for: .normal)
        } else {
            self.clearAllFiltersButton.setTitle("", for: .normal)
        }
        
        addFilterCards()
        self.handleListChange()
        self.tableView.reloadData()
    }
    
    @objc
    func removeFilter(_ sender: FilterButton) {
        if let index = self.appliedFilters.firstIndex(where: {$0.field == sender.field && $0.value == sender.value}) {
            self.appliedFilters.remove(at: index)
            self.appliedFiltersView.subviews[index].removeFromSuperview()
        }
        
        if self.appliedFilters.count == 0 {
            self.clearAllFiltersButton.setTitle("", for: .normal)
        }
        self.handleListChange()
        self.tableView.reloadData()
    }
    
    @IBAction func clearAllFilters(_ sender: UIButton) {
        self.appliedFiltersView.subviews.forEach({ $0.removeFromSuperview() })
        self.clearAllFiltersButton.setTitle("", for: .normal)
        self.appliedFilters = Array<FilterIH>()
        
        // update content size of scrollview
        self.appliedFiltersView.translatesAutoresizingMaskIntoConstraints = false
        self.appliedFiltersView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        bottomBarScrollView.contentSize = CGSize(width: 0, height: 55)
        
        self.handleListChange()
        self.tableView.reloadData()
    }
    
    func addFilterCards() {
        // remove all existing filter cards before adding
        self.appliedFiltersView.subviews.forEach({ $0.removeFromSuperview() })
            
        if self.appliedFilters.count > 0 {
            var appliedFiltersViewWidth = 0
            for i in 0...(self.appliedFilters.count - 1) {
                let filter: FilterIH = self.appliedFilters[i]
                if let filterCard = Bundle.main.loadNibNamed("FilterCard", owner: nil, options: nil)!.first as? FilterCard {
                    switch filter.field {
                    case .type:
                        filterCard.valueLabel.text = HospitalType(rawValue: filter.value)!.getHospitalDisplayString()
                    case .emsRegion:
                        filterCard.valueLabel.text = "Region " + filter.value
                    case .county:
                        filterCard.valueLabel.text = filter.value
                    case .rch:
                        filterCard.valueLabel.text = "Regional Coordinating Hospital " + filter.value
                    default:
                        filterCard.valueLabel.text = filter.value
                    }

                    filterCard.removeButton.field = filter.field
                    filterCard.removeButton.value = filter.value
                    filterCard.removeButton.addTarget(self, action: #selector(self.removeFilter(_:)), for: .touchUpInside)
                    self.appliedFiltersView.addArrangedSubview(filterCard)
                    
                    filterCard.translatesAutoresizingMaskIntoConstraints = false
                    let filterCardWidth = filterCard.removeButton.frame.width + filterCard.valueLabel.intrinsicContentSize.width + 12
                    filterCard.widthAnchor.constraint(equalToConstant: filterCardWidth).isActive = true
                    filterCard.heightAnchor.constraint(equalToConstant: 22).isActive = true
                    
                    appliedFiltersViewWidth += Int(filterCardWidth) + 10
                }
            }
                
            self.appliedFiltersView.translatesAutoresizingMaskIntoConstraints = false
            self.appliedFiltersView.widthAnchor.constraint(equalToConstant: CGFloat(appliedFiltersViewWidth)).isActive = true
            bottomBarScrollView.contentSize = CGSize(width: appliedFiltersViewWidth, height: 55)
        }
    }
    
    @IBAction func onSortClicked(_ sender: UIBarButtonItem) {
        sortSelectorView.delegate = self
        popupHandler.displayPopup(sortSelectorView, sortSelectorViewHeight)
    }

    func onSortSelected(_ sort: SortType?) {
        popupHandler.handleDismiss()
        appliedSort = sort
        self.handleListChange()
        self.tableView.reloadData()
    }
    
    func handleSort() {
        if appliedSort == nil {
            return
        }
        switch appliedSort {
        case .az:
            self.showingList.sort {
                $0.name < $1.name
            }
        case .distance:
            self.showingList.sort {
                $0.distance < $1.distance
            }
        case .nedocs:
            self.showingList.sort {
                $0.nedocsScore < $1.nedocsScore
            }
        case .defaultSort:
            self.showingList.sort {
                $0.score > $1.score
            }
        default:
            self.showingList.sort {
                $0.score > $1.score
            }
        }
    }
    
    func handleFilter() {
        if (!searchActive) {
            self.showingList = self.hospitals
        }
        if appliedFilters.count > 0 {
            for filter in appliedFilters {
                switch filter.field {
                case .county:
                    var newHospitals = Array<HospitalIH>()
                    newHospitals.append(contentsOf: self.showingList.filter({ (hos) -> Bool in
                        let tmp: String = hos.county
                        return tmp == filter.value
                        }))
                    self.showingList = newHospitals
                case .emsRegion:
                    var newHospitals = Array<HospitalIH>()
                    newHospitals.append(contentsOf: self.showingList.filter({ (hos) -> Bool in
                        let tmp: String = hos.regionNumber
                        return tmp == filter.value
                        }))
                    self.showingList = newHospitals
                case .rch:
                    var newHospitals = Array<HospitalIH>()
                    newHospitals.append(contentsOf: self.showingList.filter({ (hos) -> Bool in
                        let tmp: String = hos.rch
                        return tmp == filter.value
                        }))
                    self.showingList = newHospitals
                case .type:
                    var newHospitals = Array<HospitalIH>()
                    let type = HospitalType(rawValue: filter.value)
                    newHospitals.append(contentsOf: self.showingList.filter({ (hos) -> Bool in
                        let tmp: Array<HospitalType> = hos.specialtyCenters
                        return tmp.contains(type!)
                        }))
                    self.showingList = newHospitals
                default:
                    break
                }
            }
        }
    }
    
    func handleListChange() {
        self.handleFilter()
        self.handleSort()
        self.handlePins()
    }
}
