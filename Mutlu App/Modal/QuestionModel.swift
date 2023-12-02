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

struct QuestionsModel {
    let title: String
    let answer: String
    let image: String
    
    init(
        title: String,
        answer: String,
        image: String
    ){
        self.title = title
        self.answer = answer
        self.image = image
    }
}

struct VideosModel {
    let title: String
    let detail: String
    let image: String
    let link: String
    
    init(
        title: String,
        detail: String,
        image: String,
        link: String
    ) {
        self.title = title
        self.detail = detail
        self.image = image
        self.link = link
    }
}
