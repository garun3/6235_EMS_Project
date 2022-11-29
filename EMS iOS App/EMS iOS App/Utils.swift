//
//  Utils.swift
//  EMS iOS App
//

import Foundation
import UIKit

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension NedocsScore {
    func getNedocsColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .normal:
            color = UIColor(rgb: 0x70ad47)
        case .busy:
            color = UIColor(rgb: 0xfdd835)
        case .overcrowded:
            color = UIColor(rgb: 0xf9a825)
        case .severe:
            color = UIColor(rgb: 0xd32f2f)
        }
        return color
    }
}

extension HospitalType {
    func getHospitalIcon() -> UIImage {
        var image: UIImage!
        switch self {
        case .adultTraumaCenterLevelI:
            image = UIImage(named: "Person1Icon")
        case .adultTraumaCenterLevelII:
            image = UIImage(named: "Person2Icon")
        case .adultTraumaCenterLevelIII:
            image = UIImage(named: "Person3Icon")
        case .adultTraumaCenterLevelIV:
            image = UIImage(named: "Person4Icon")
        case .pediatricTraumaCenterLevelI:
            image = UIImage(named: "Child1Icon")
        case .pediatricTraumaCenterLevelII:
            image = UIImage(named: "Child2Icon")
        case .comprehensiveStrokeCenter:
            image = UIImage(named: "BrainComprehensiveIcon")
        case .thrombectomyStrokeCenter:
            image = UIImage(named: "BrainThrombectomyIcon")
        case .primaryStrokeCenter:
            image = UIImage(named: "BrainIcon")
        case .remoteStrokeCenter:
            image = UIImage(named: "BrainRemoteIcon")
        case .emergencyCardiacCenterLevelI:
            image = UIImage(named: "Heart1Icon")
        case .emergencyCardiacCenterLevelII:
            image = UIImage(named: "Heart2Icon")
        case .emergencyCardiacCenterLevelIII:
            image = UIImage(named: "Heart3Icon")
        case .neonatalCenterLevelI:
            image = UIImage(named: "Baby1Icon")
        case .neonatalCenterLevelII:
            image = UIImage(named: "Baby2Icon")
        case .neonatalCenterLevelIII:
            image = UIImage(named: "Baby3Icon")
        case .maternalCenterLevelI:
            image = UIImage(named: "Pregnant1Icon")
        case .maternalCenterLevelII:
            image = UIImage(named: "Pregnant2Icon")
        case .maternalCenterLevelIII:
            image = UIImage(named: "Pregnant3Icon")
        }
        return image
    }
    
    func getHospitalDisplayString() -> String {
        var label: String!
        switch self {
        case .adultTraumaCenterLevelI:
            label = "Adult Trauma Center - Level 1"
        case .adultTraumaCenterLevelII:
            label = "Adult Trauma Center - Level 2"
        case .adultTraumaCenterLevelIII:
            label = "Adult Trauma Center - Level 3"
        case .adultTraumaCenterLevelIV:
            label = "Adult Trauma Center - Level 4"
        case .pediatricTraumaCenterLevelI:
            label = "Pediatric Trauma Center - Level 1"
        case .pediatricTraumaCenterLevelII:
            label = "Pediatric Trauma Center - Level 2"
        case .comprehensiveStrokeCenter:
            label = "Comprehensive Stroke Center"
        case .thrombectomyStrokeCenter:
            label = "Thrombectomy Stroke Center"
        case .primaryStrokeCenter:
            label = "Primary Stroke Center"
        case .remoteStrokeCenter:
            label = "Remote Treatment Stroke Center"
        case .emergencyCardiacCenterLevelI:
            label = "Emergency Cardiac Care Center - Level 1"
        case .emergencyCardiacCenterLevelII:
            label = "Emergency Cardiac Care Center - Level 2"
        case .emergencyCardiacCenterLevelIII:
            label = "Emergency Cardiac Care Center - Level 3"
        case .neonatalCenterLevelI:
            label = "Neonatal Center - Level 1"
        case .neonatalCenterLevelII:
            label = "Neonatal Center - Level 2"
        case .neonatalCenterLevelIII:
            label = "Neonatal Center - Level 3"
        case .maternalCenterLevelI:
            label = "Maternal Center - Level 1"
        case .maternalCenterLevelII:
            label = "Maternal Center - Level 2"
        case .maternalCenterLevelIII:
            label = "Maternal Center - Level 3"
        }
        return label
    }
}
