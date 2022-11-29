//
//  RecommendationIH.swift
//  EMS iOS App
//


import Foundation

class RecommendationIH: NSObject {
    var isOver18: Bool!
    var needsTraumaCenter: Bool!
    var needsStrokeCenter: Bool!
    var needsCardiacCenter: Bool!
    var needsPregnancyCenter: Bool!
    var needsNeonatalCenter: Bool!
    var significanceLevel: Int!
    
    init(isOver18: Bool, needsTraumaCenter: Bool, needsStrokeCenter: Bool, needsCardiacCenter: Bool, needsPregnancyCenter: Bool, needsNeonatalCenter: Bool, significanceLevel: Int) {
        self.isOver18 = isOver18
        self.needsTraumaCenter = needsTraumaCenter
        self.needsStrokeCenter = needsStrokeCenter
        self.needsCardiacCenter = needsCardiacCenter
        self.needsPregnancyCenter = needsPregnancyCenter
        self.needsNeonatalCenter = needsNeonatalCenter
        self.significanceLevel = significanceLevel
    }
    
    private func getRecommendationWeights() -> Array<Double> {
        if !needsTraumaCenter && !needsStrokeCenter && !needsCardiacCenter && !needsPregnancyCenter && !needsNeonatalCenter {
            return [0.0, 2.0, 4.0, 3.0]
        }
        if self.significanceLevel <= 1 {
            return [4.0, 1.0, 3.0, 2.0]
        }
        return [4.0, 1.0, 4.0, 2.0]
    }
    

    func getHospitalRecommendations(hospitals: Array<HospitalIH>) -> Array<HospitalIH> {
        var recommendations = hospitals
        // Write recommendation algorithm
        var specialtyScore: Double = 0
        var diversionScore: Double = 0
        var distanceScore: Double = 0
        var nedocsScore: Double = 0
        
        let weights = self.getRecommendationWeights()
        let specialtyWeight: Double = weights[0]
        let diversionWeight: Double = weights[1]
        let distanceWeight: Double = weights[2]
        let nedocsWeight: Double = weights[3]
        
        var distances = [Double]()
        var specialtyNeeds = [String]()
        if self.needsTraumaCenter {
            if self.isOver18 {
                specialtyNeeds.append("adultTrauma")
            } else {
                specialtyNeeds.append("pediatricTrauma")
            }
        }
        if self.needsStrokeCenter {
            specialtyNeeds.append("stroke")
        }
        if self.needsCardiacCenter {
            specialtyNeeds.append("cardiac")
        }
        if self.needsPregnancyCenter {
            specialtyNeeds.append("pregnancy")
        }
        if self.needsNeonatalCenter {
            specialtyNeeds.append("neonatal")
        }

        for hos in recommendations {
            distances.append(hos.distance)
        }
        let minDistance: Double = distances.min() ?? 0.0
        let maxDistance: Double = distances.max() ?? 500.0
        var specialtyCenterLevel = 0
        var specialtyCenterType = ""
        
        for hospital in recommendations {
            specialtyScore = 0
            diversionScore = 0
            distanceScore = 0
            nedocsScore = 0
            
            //Specialty Center
            for specialtyCenter in hospital.specialtyCenters {
                specialtyCenterLevel = specialtyCenter.level
                specialtyCenterType = specialtyCenter.type
                if specialtyNeeds.contains(specialtyCenterType) {
                    switch self.significanceLevel {
                    case 0:
                        specialtyScore += 1
                    case 1:
                        if specialtyCenterType == "adultTrauma" || specialtyCenterType == "stroke" {
                            if specialtyCenterLevel == 4 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                        } else if specialtyCenterType == "cardiac" || specialtyCenterType == "neonatal" || specialtyCenterType == "maternal" {
                            if specialtyCenterLevel == 3 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                        } else {
                            specialtyScore += 1
                          }
                    case 2:
                        if specialtyCenterType == "adultTrauma" || specialtyCenterType == "stroke" {
                            if specialtyCenterLevel == 4  {
                                specialtyScore += 0.5
                            } else if specialtyCenterLevel == 3 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                        } else if specialtyCenterType == "cardiac" || specialtyCenterType == "neonatal" || specialtyCenterType == "maternal" {
                            if specialtyCenterLevel == 3 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                        } else {
                            if specialtyCenterLevel == 2 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                          }
                    case 3:
                        if specialtyCenterType == "adultTrauma" || specialtyCenterType == "stroke" {
                            if specialtyCenterLevel == 4  {
                                specialtyScore += 0.25
                            } else if specialtyCenterLevel == 3 {
                                specialtyScore += 0.5
                            } else if specialtyCenterLevel == 2 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                        } else if specialtyCenterType == "cardiac" || specialtyCenterType == "neonatal" || specialtyCenterType == "maternal" {
                            if specialtyCenterLevel == 3 {
                                specialtyScore += 0.5
                            } else if specialtyCenterLevel == 2 {
                                specialtyScore += 0.75
                            } else {
                                specialtyScore += 1
                            }
                        } else {
                            if specialtyCenterLevel == 2 {
                                specialtyScore += 0.75
                            }
                            else {
                                specialtyScore += 1
                            }
                          }
                    default:
                        specialtyScore += 0
                    }
                }
            }
            if specialtyNeeds.count > 0 {
                specialtyScore = specialtyScore / Double(specialtyNeeds.count)
            }
            
            //Diversion
            diversionScore = 1
            if hospital.diversions.count > 0 {
                for diversion in hospital.diversions {
                    if diversion.contains("Diversion") || diversion.contains("CALL") {
                        diversionScore = 0
                        break
                    }
                    if diversion.contains("Saturation") {
                        diversionScore = 0.5
                    }
                }
            }
            
            //Distance
            distanceScore = (hospital.distance - minDistance) / (maxDistance - minDistance)
            distanceScore = 1 - distanceScore
            
            //Nedocs
            switch hospital.nedocsScore {
            case .normal:
                nedocsScore = 1
            case .busy:
                nedocsScore = 0.666
            case .overcrowded:
                nedocsScore = 0.333
            case .severe:
                nedocsScore = 0
            default:
                nedocsScore = 0
            }
            
            hospital.score = specialtyScore * specialtyWeight +
                                diversionScore * diversionWeight +
                                distanceScore * distanceWeight +
                                nedocsScore * nedocsWeight
        }
        
        recommendations.sort{
            $0.score > $1.score
        }
        return recommendations
    }
}
