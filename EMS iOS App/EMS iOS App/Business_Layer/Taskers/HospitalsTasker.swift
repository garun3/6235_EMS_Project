//
//  HospitalsTasker.swift
//  EMS iOS App
//

import UIKit
import MapKit

class HospitalsTasker: NSObject {
    
    var locationManager: CLLocationManager!

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
    }
    
    func getHospitalDistances(hospitals: Array<HospitalIH>, finished: @escaping (_ hospitals: Array<HospitalIH>?) -> Void) {
        let currentLocation: CLLocation = self.determineCurrentLocation()
        var count = 0
        for hospital in hospitals {
            let hospitalLocation = CLLocation(latitude: CLLocationDegrees(exactly: hospital.lat)!, longitude: CLLocationDegrees(exactly: hospital.long)!)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: hospitalLocation.coordinate))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                var distance = currentLocation.distance(from: hospitalLocation)
                if let unwrappedResponse = response {
                    let route = unwrappedResponse.routes[0]
                    distance = route.distance
                }
                distance = (distance / 1000) * 0.62137
                distance = Double(round(distance * 100) / 100)
                hospital.distance = distance
                count += 1
                if count == hospitals.count {
                    DispatchQueue.main.async {
                        finished(hospitals)
                    }
                }
            }
        }
    }
    
    func determineCurrentLocation() -> CLLocation {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            if let location = self.locationManager.location {
                return location
            } else {
                return self.determineCurrentLocation()
            }
        }
        return CLLocation()
    }
    
    func getAllHospitals(failure: @escaping () -> Void, success: @escaping (_ hospitals: Array<HospitalIH>?) -> Void){
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makeGetRequest(forBaseURL: BackendURLs.GET_HOSPITALS_URL, withParams: "", failure: {
            failure()
        }, success: {(data) in
            let hospitals = HospitalIH.parseJson(jsonData: data)
            success(hospitals)
        })
    }
    
}
