//
//  FontExtension.swift
//  Mutlu App
//
//  Created by Kullanici on 31.03.2023.
//

import UIKit

enum FontSize {
    case small
    case medium
    case large
    
    var size: CGFloat {
        switch self {
        case .small:
            return UIDevice.current.userInterfaceIdiom == .phone ? 14 : 18
        case .medium:
            return UIDevice.current.userInterfaceIdiom == .phone ? 20 : 35
        case .large:
            return UIDevice.current.userInterfaceIdiom == .phone ? 35 : 55
        }
    }
}
