//
//  Model.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//

import UIKit

class QuestionModel {
    let title: String
    let options: [String]?
    var isOpened: Bool = false
    let image: [String]?
    
    init(
        title: String,
        options: [String],
        isOpened: Bool = false,
        image: [String]
    ){
        self.title = title
        self.options = options
        self.isOpened = isOpened
        self.image = image
    }
}
