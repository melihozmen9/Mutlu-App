//
//  ZoomModel.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import Foundation

struct ZoomModel {
    let title: String
    let date: String
    let image: String
    let location: String
    
    init(
        title: String,
        date: String,
        image: String,
        location: String
    ) {
        self.title = title
        self.date = date
        self.image = image
        self.location = location
    }
}
