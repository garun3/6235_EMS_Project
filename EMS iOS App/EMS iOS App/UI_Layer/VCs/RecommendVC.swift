//
//  RecommendVC.swift
//  EMS iOS App
//

import UIKit

class RecommendVC: UIViewController {
    
    
    @IBOutlet var ageOver18: FilterCheckBox!
    @IBOutlet var ageUnder18: FilterCheckBox!
    var isOver18: Bool = false
    
    @IBOutlet var traumaYes: FilterCheckBox!
    @IBOutlet var traumaNo: FilterCheckBox!
    var needsTraumaCenter: Bool = false
    
    @IBOutlet var strokeYes: FilterCheckBox!
    @IBOutlet var strokeNo: FilterCheckBox!
    var needsStrokeCenter: Bool = false
    
    @IBOutlet var cardiacYes: FilterCheckBox!
    @IBOutlet var cardiacNo: FilterCheckBox!
    var needsCardiacCenter: Bool = false
    
    @IBOutlet var pregnancyYes: FilterCheckBox!
    @IBOutlet var pregnancyNo: FilterCheckBox!
    var needsPregnancyCenter: Bool = false
    
    @IBOutlet var neonatalYes: FilterCheckBox!
    @IBOutlet var neonatalNo: FilterCheckBox!
    var needsNeonatalCenter: Bool = false
    
    @IBOutlet var significanceSlider: UISlider!
    var significanceLevel: Int = 0
    
    var recommender: RecommendationIH!
    var hospitals: Array<HospitalIH>!
    
    @IBAction func sliderMoved(sender: UISlider) {
        self.significanceLevel = Int(Float(lroundf(significanceSlider.value)))
        sender.setValue(Float(self.significanceLevel), animated: true)
    }
    
    @IBAction func centerClicked(sender: FilterCheckBox) {
        // Age
        if sender == self.ageOver18 && !sender.isChecked {
            self.ageUnder18.isChecked = false
        }
        if sender == self.ageUnder18 && !sender.isChecked {
            self.ageOver18.isChecked = false
        }
        // Trauma center
        if sender == self.traumaYes && !sender.isChecked {
            self.traumaNo.isChecked = false
        }
        if sender == self.traumaNo && !sender.isChecked {
            self.traumaYes.isChecked = false
        }
        // Stroke center
        if sender == self.strokeYes && !sender.isChecked {
            self.strokeNo.isChecked = false
        }
        if sender == self.strokeNo && !sender.isChecked {
            self.strokeYes.isChecked = false
        }
        // Cardiac center
        if sender == self.cardiacYes && !sender.isChecked {
            self.cardiacNo.isChecked = false
        }
        if sender == self.cardiacNo && !sender.isChecked {
            self.cardiacYes.isChecked = false
        }
        // Pregnancy center
        if sender == self.pregnancyYes && !sender.isChecked {
            self.pregnancyNo.isChecked = false
        }
        if sender == self.pregnancyNo && !sender.isChecked {
            self.pregnancyYes.isChecked = false
        }
        // Neonatal center
        if sender == self.neonatalYes && !sender.isChecked {
            self.neonatalNo.isChecked = false
        }
        if sender == self.neonatalNo && !sender.isChecked {
            self.neonatalYes.isChecked = false
        }
    }
    
    @IBAction func goClicked(_: UIButton) {
        self.isOver18 = self.ageOver18.isChecked
        self.needsTraumaCenter = self.traumaYes.isChecked
        self.needsStrokeCenter = self.strokeYes.isChecked
        self.needsCardiacCenter = self.cardiacYes.isChecked
        self.needsPregnancyCenter = self.pregnancyYes.isChecked
        self.needsNeonatalCenter = self.neonatalYes.isChecked
        self.recommender = RecommendationIH(isOver18: self.isOver18, needsTraumaCenter: self.needsTraumaCenter, needsStrokeCenter: self.needsStrokeCenter, needsCardiacCenter: self.needsCardiacCenter, needsPregnancyCenter: self.needsPregnancyCenter, needsNeonatalCenter: self.needsNeonatalCenter, significanceLevel: self.significanceLevel)
        self.hospitals = self.recommender.getHospitalRecommendations(hospitals: self.hospitals)
        self.performSegue(withIdentifier: "viewRecommendedHospitals", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRecommendedHospitals" {
            let navVC = segue.destination as! UINavigationController
            let homeVC = navVC.viewControllers.first as! HomeVC
            homeVC.hospitals = self.hospitals
            homeVC.appliedSort = SortType.defaultSort
            homeVC.recommender = self.recommender
            homeVC.isMostApplicableView = true
        }
    }

}
