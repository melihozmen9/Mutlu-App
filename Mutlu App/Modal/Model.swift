//
//  Model.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//

import UIKit

class section {
    let title: String
    let options: [String]
    var isOpened: Bool = false
    
    init(
        title: String,
        options: [String],
        isOpened: Bool = false
    ){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}
