//
//  FilterIH.swift
//  EMS iOS App
//

import UIKit

class FilterIH: NSObject {
    var field: FilterType!
    var value: String!
    
    init(field: FilterType, value: String) {
        self.field = field
        self.value = value
    }
}
