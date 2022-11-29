//
//  LoadingVC.swift
//  EMS iOS App
//

import UIKit
import MapKit

class LoadingVC: UIViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    var hospitals: Array<HospitalIH>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        let tasker = HospitalsTasker()
        tasker.locationManager.requestWhenInUseAuthorization()
        self.hospitals = Array<HospitalIH>()
        tasker.getAllHospitals(failure: {
            print("Failure")
        }, success: { (hospitals) in
            guard let hospitals = hospitals else {
                self.hospitals = Array<HospitalIH>()
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.performSegue(withIdentifier: "goToStart", sender: self)
                }
                return
            }
            self.hospitals = hospitals
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: "goToStart", sender: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let startVC = segue.destination as! StartVC
        startVC.hospitals = self.hospitals
    }
    

}
