//
//  Exensions.swift
//  Mutlu App
//
//  Created by Kullanici on 19.08.2023.
//

import UIKit

extension UIView {
    func addSubViews(_ view: UIView...) {
        view.forEach{self.addSubview($0)}
}
}
