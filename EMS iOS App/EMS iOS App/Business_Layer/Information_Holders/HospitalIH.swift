//
//  HospitalIH.swift
//  EMS iOS App
//

import UIKit

class HospitalIH: NSObject {
    
    var name: String!
    var nedocsScore: NedocsScore!
    var specialtyCenters: [HospitalType]!
    var distance: Double!
    var lat: Double!
    var long: Double!
    var hasDiversion: Bool!
    var diversions: [String]!
    var address: String!
    var phoneNumber: String!
    var regionNumber: String!
    var county: String!
    var rch: String! //Regional Coordinating Hospital
    var lastUpdated: Date!
    var score: Double!
    
    var isFavorite = false
    
    init(name: String, nedocsScore: NedocsScore, specialtyCenters: [HospitalType], distance: Double, lat: Double, long: Double, hasDiversion: Bool, diversions: [String], address: String, phoneNumber: String, regionNumber: String, county: String, rch: String, lastUpdated: Date) {
        self.name = name
        self.nedocsScore = nedocsScore
        self.specialtyCenters = specialtyCenters
        self.distance = distance
        self.lat = lat
        self.long = long
        self.hasDiversion = hasDiversion
        self.diversions = diversions
        self.address = address
        self.phoneNumber = phoneNumber
        self.regionNumber = regionNumber
        self.county = county
        self.rch = rch
        self.lastUpdated = lastUpdated
        self.score = 0.0
    }
    
    class func parseJson(jsonData: Data) -> Array<HospitalIH>? {
        guard let hospitals = try? JSONSerialization.jsonObject(with: jsonData) as? Array<[String: Any]> else {
            return nil
        }
        var result: Array<HospitalIH> = Array<HospitalIH>()
        for hospital in hospitals {
            let name = hospital["name"] as! String
            let street = hospital["street"] as! String
            let city = hospital["city"] as! String
            let state = hospital["state"] as! String
            let zip = hospital["zip"] as! String
            let phone = hospital["phone"] as! String
            var rch_value = ""
            if let rch = hospital["rch"] as? String {
                rch_value = rch
            }
            let emsRegion = hospital["ems_region"] as! String
            var county_val = ""
            if let county = hospital["county"] as? String {
                county_val = county
            }
            let diversions = hospital["diversions"] as! Array<String>
            let nedocsScore = hospital["nedocs_score"] as! String
            let specialtyCenters = hospital["specialty_centers"] as! Array<String>
            var centers: [HospitalType] = [HospitalType]()
            for center in specialtyCenters {
                if let type = HospitalType(rawValue: center) {
                    centers.append(type)
                } else {
                    continue
                }
            }
            let address = street + ", " + city + ", " + state + " " + zip
            let latStr = hospital["lat"] as! String
            let longStr = hospital["long"] as! String
            let lat: Double = (latStr as NSString).doubleValue
            let long: Double = (longStr as NSString).doubleValue
            

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let lastUpdated = dateFormatter.date(from: hospital["last_updated"] as! String)!

            let hosp = HospitalIH(name: name, nedocsScore: NedocsScore(rawValue: nedocsScore)!, specialtyCenters: centers, distance: -1.0, lat: lat, long: long, hasDiversion: (diversions.count > 0 && diversions[0] != "Normal"), diversions: diversions, address: address, phoneNumber: phone, regionNumber: emsRegion, county: county_val, rch: rch_value, lastUpdated: lastUpdated)
            result.append(hosp)
        }
        return result
    }

}
