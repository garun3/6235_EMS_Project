//
//  Utils.swift
//  EMS iOS App
//

import Foundation

enum NedocsScore: String, Codable, Comparable {
    case normal = "Normal"
    case busy = "Busy"
    case overcrowded = "Overcrowded"
    case severe = "Severe"
    
    private var comparisonValue: Int {
            switch self {
            case .normal:
                return 0
            case .busy:
                return 1
            case .overcrowded:
                return 2
            case .severe:
                return 3
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.comparisonValue < rhs.comparisonValue
        }
}
enum HospitalType: String, Codable, CaseIterable {
    case adultTraumaCenterLevelI = "Adult Trauma Centers-Level I"
    case adultTraumaCenterLevelII = "Adult Trauma Centers-Level II"
    case adultTraumaCenterLevelIII = "Adult Trauma Centers-Level III"
    case adultTraumaCenterLevelIV = "Adult Trauma Center - Level IV"
    case pediatricTraumaCenterLevelI = "Pediatric Trauma Centers-Pediatric Level I"
    case pediatricTraumaCenterLevelII = "Pediatric Trauma Centers-Pediatric Level II"
    case comprehensiveStrokeCenter = "Stroke Centers-Comprehensive Stroke Center"
    case thrombectomyStrokeCenter = "Stroke Centers-Thrombectomy Capable Stroke Center"
    case primaryStrokeCenter = "Stroke Centers-Primary Stroke Center"
    case remoteStrokeCenter = "Stroke Centers-Remote Treatment Stroke Center"
    case emergencyCardiacCenterLevelI = "Emergency Cardiac Care Center-Level I ECCC"
    case emergencyCardiacCenterLevelII = "Emergency Cardiac Care Center-Level II ECCC"
    case emergencyCardiacCenterLevelIII = "Emergency Cardiac Care Center-Level III ECCC"
    case neonatalCenterLevelI = "Neonatal Center Designation-Level I Neonatal Center"
    case neonatalCenterLevelII = "Neonatal Center Designation-Level II Neonatal Center"
    case neonatalCenterLevelIII = "Neonatal Center Designation-Level III Neonatal Center"
    case maternalCenterLevelI = "Maternal Center Designation-Level I Maternal Center"
    case maternalCenterLevelII = "Maternal Center Designation-Level II Maternal Center"
    case maternalCenterLevelIII = "Maternal Center Designation-Level III Maternal Center"
    
    public var level: Int {
            switch self {
            case .adultTraumaCenterLevelI:
                return 1
            case .adultTraumaCenterLevelII:
                return 2
            case .adultTraumaCenterLevelIII:
                return 3
            case .adultTraumaCenterLevelIV:
                return 4
            case .pediatricTraumaCenterLevelI:
                return 1
            case .pediatricTraumaCenterLevelII:
                return 2
            case .comprehensiveStrokeCenter:
                return 1
            case .thrombectomyStrokeCenter:
                return 2
            case .primaryStrokeCenter:
                return 3
            case .remoteStrokeCenter:
                return 4
            case .emergencyCardiacCenterLevelI:
                return 1
            case .emergencyCardiacCenterLevelII:
                return 2
            case .emergencyCardiacCenterLevelIII:
                return 3
            case .neonatalCenterLevelI:
                return 1
            case .neonatalCenterLevelII:
                return 2
            case .neonatalCenterLevelIII:
                return 3
            case .maternalCenterLevelI:
                return 1
            case .maternalCenterLevelII:
                return 2
            case .maternalCenterLevelIII:
                return 3
            }
        }
    
    public var type: String {
            switch self {
            case .adultTraumaCenterLevelI:
                return "adultTrauma"
            case .adultTraumaCenterLevelII:
                return "adultTrauma"
            case .adultTraumaCenterLevelIII:
                return "adultTrauma"
            case .adultTraumaCenterLevelIV:
                return "adultTrauma"
            case .pediatricTraumaCenterLevelI:
                return "pediatricTrauma"
            case .pediatricTraumaCenterLevelII:
                return "pediatricTrauma"
            case .comprehensiveStrokeCenter:
                return "stroke"
            case .thrombectomyStrokeCenter:
                return "stroke"
            case .primaryStrokeCenter:
                return "stroke"
            case .remoteStrokeCenter:
                return "stroke"
            case .emergencyCardiacCenterLevelI:
                return "cardiac"
            case .emergencyCardiacCenterLevelII:
                return "cardiac"
            case .emergencyCardiacCenterLevelIII:
                return "cardiac"
            case .neonatalCenterLevelI:
                return "neonatal"
            case .neonatalCenterLevelII:
                return "neonatal"
            case .neonatalCenterLevelIII:
                return "neonatal"
            case .maternalCenterLevelI:
                return "maternal"
            case .maternalCenterLevelII:
                return "maternal"
            case .maternalCenterLevelIII:
                return "maternal"
            }
        }
}

enum FilterType: String {
    case county = "County"
    case emsRegion = "EMS Region"
    case rch = "Regional Coordinating Hospital"
    case type = "Type"
}

enum SortType: String {
    case distance = "Distance"
    case az = "Alphabetical"
    case nedocs = "NEDOCS Score"
    case defaultSort = "Default Sort"
}

struct Hospital: Codable {
    var name: String!
    var nedocsScore: NedocsScore!
    var specialtyCenters: [HospitalType]!
    var distance: Double!
    var lat: Double?
    var long: Double?
    var hasDiversion: Bool!
    var diversions: [String]!
    var address: String!
    var phoneNumber: String!
    var regionNumber: String!
    var county: String!
    var rch: String! //Regional Coordinating Hospital
}
