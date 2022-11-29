//
//  FilterButton.swift
//  EMS iOS App
//

import UIKit

class FilterButton: UIButton {
    var field: FilterType!
    var value: String!
    
    convenience init(field: FilterType, value: String) {
        self.init()
        self.field = field
        self.value = value
    }
}
