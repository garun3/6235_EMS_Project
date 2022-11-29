//
//  StartVC.swift
//  EMS iOS App
//

import UIKit
import CoreLocation

class StartVC: UIViewController, CLLocationManagerDelegate {
    
    var hospitals: Array<HospitalIH>!
    @IBOutlet var viewAllHospitalsBtn: UIButton!
    @IBOutlet var viewHospitalsByDistanceBtn: UIButton!
    @IBOutlet var viewMostApplicableBtn: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    var viewByDistance: Bool = false
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        self.viewAllHospitalsBtn.layer.cornerRadius = 5.0
        self.viewHospitalsByDistanceBtn.layer.cornerRadius = 5.0
        self.viewMostApplicableBtn.layer.cornerRadius = 5.0
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // This method is only used to request permission to access the user's location
                }
            }
        }
    }
    
    @IBAction func viewAllHospitals(_: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let tasker = HospitalsTasker()
        tasker.getHospitalDistances(hospitals: self.hospitals, finished: { (hospitals) in
            self.hospitals = hospitals
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "viewHospitals", sender: self)
        })
    }
    
    @IBAction func viewHospitalsByDistance(_: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.viewByDistance = true
        let tasker = HospitalsTasker()
        tasker.getHospitalDistances(hospitals: self.hospitals, finished: { (hospitals) in
            self.hospitals = hospitals
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "viewHospitals", sender: self)
        })
    }
    
    @IBAction func viewHospitalsByMostApplicable(_: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        let tasker = HospitalsTasker()
        tasker.getHospitalDistances(hospitals: self.hospitals, finished: { (hospitals) in
            self.hospitals = hospitals
            self.spinner.stopAnimating()
            self.performSegue(withIdentifier: "recommendHospital", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewHospitals" {
            let navVC = segue.destination as! UINavigationController
            let homeVC = navVC.viewControllers.first as! HomeVC
            homeVC.hospitals = self.hospitals
            if self.viewByDistance {
                homeVC.appliedSort = SortType.distance
            } else {
                homeVC.appliedSort = SortType.defaultSort
            }
        }
        if segue.identifier == "recommendHospital" {
            let navVC = segue.destination as! UINavigationController
            let recVC = navVC.viewControllers.first as! RecommendVC
            recVC.hospitals = self.hospitals
        }
    }

}
