//
//  Enums.swift
//  Mutlu App
//
//  Created by Kullanici on 7.11.2023.
//
import UIKit
import Foundation

enum DataCategory: String {
    case volunteers = "volunteers"
    case parents = "parents"
    case children = "children"
}

enum UserType: String {
    case volunteer = "volunteer"
    case parent = "parent"
    case child = "child"
    
    var category : String {
        switch self {
            
        case .volunteer:
            return "gonullu"
        case .parent:
            return "refakatci"
        case .child:
            return "children"
        }
    }
}

enum AgeRange: String {
    case age7to12 = "7-12"
    case age13to15 = "12-15"
    case age16to18 = "15-18"
}

enum Font { 
    case kohoRegular12
    case kohoRegular14
    case kohoMedium12
    case kohoMedium14
    case kohoMedium15
    case kohoMedium16
  case kohoSemibold11
    case kohoSemibold14
    case kohoSemibold16
    case kohoSemiBold18
    case kohoSemiBold24
    case kohoSemibold32
    case kohoBold16
    case kohoBold32
    case urbanMedium16
    case vollkornBold18
    case vollkornSemibold18
    case vollkornMedium15
    var chooseFont: UIFont {
        switch self {
        case .kohoRegular12:
            return UIFont(name: "Koho-Regular", size: 12)!
        case .kohoRegular14:
            return UIFont(name: "Koho-Regular", size: 14)!
        case .kohoMedium12:
            return UIFont(name: "Koho-Medium", size: 12)!
        case .kohoMedium14:
            return UIFont(name: "Koho-Medium", size: 14)!
        case .kohoMedium15:
            return UIFont(name: "Koho-Medium", size: 15)!
        case .kohoMedium16:
            return UIFont(name: "Koho-Medium", size: 16)!
        case .kohoSemibold11:
            return UIFont(name: "Koho-SemiBold", size: 11)!
        case .kohoSemibold14:
            return UIFont(name: "Koho-SemiBold", size: 14)!
        case .kohoSemibold16:
            return UIFont(name: "Koho-SemiBold", size: 16)!
        case .kohoSemiBold18:
            return UIFont(name: "Koho-SemiBold", size: 18)!
        case .kohoSemiBold24:
            return UIFont(name: "Koho-SemiBold", size: 24)!
        case .kohoSemibold32:
            return UIFont(name: "Koho-SemiBold", size: 32)!
        case .kohoBold16:
            return UIFont(name: "Koho-Bold", size: 16)!
        case .kohoBold32:
            return UIFont(name: "Koho-Bold", size: 32)!
        case .urbanMedium16:
            return UIFont(name: "Urbanist-Medium", size: 16)!
        case .vollkornBold18:
            return UIFont(name: "Vollkorn-Bold", size: 18)!
        case .vollkornSemibold18:
            return UIFont(name: "Vollkorn-SemiBold", size: 18)!
        case .vollkornMedium15:
            return UIFont(name: "Vollkorn-Medium", size: 15)!
        }
    }
}

import UIKit

enum CustomColor {
    case gri
    case lightGri
    case lightGri2
    case gri2
    case anaSarı
    case beyaz
    case siyah
    case orange
    case navbarSarı
    case lightSarı
    case lightSarı2
    case yellow4
    case envelopeYellow
    case envelopeBackgroundYellow
    case green
    case lightGreen
    case avokadoGreen
    case metinGrisi
    case metinGrisi2
    case blueOpacity15
    case lightBlue
    case purpleEnvelope
    case purpleOpacity15
    case purple2
    case lightOrange
    case pembe
    case koyuPembe
    case lightPembe
    case attributedWhite
    case letterTextColor
    case letterSenderColor
    var color: UIColor {
        switch self {
        case .gri:
            return UIColor(hex: "707B72")
        case .lightGri:
            return UIColor(hex: "B1B1B1")
        case .lightGri2:
            return UIColor(hex: "DCDCDC")
        case .gri2:
            return UIColor(hex: "959595")
        case .attributedWhite:
            return UIColor(hex: "FAFAFA")
        case .anaSarı:
            return UIColor(hex: "FAD860")
        case .beyaz:
            return UIColor(hex: "FFFFFF")
        case .siyah:
            return UIColor(hex: "000000")
        case .orange:
            return UIColor(hex: "FA6D27")
        case .navbarSarı:
            return UIColor(hex: "FAD860")
        case .lightSarı:
            return UIColor(hex: "FFE9AB")
        case .lightSarı2:
            return UIColor(hex: "FAF5E4")
        case .yellow4:
            return UIColor(hex: "F9CC4B")
        case .envelopeYellow:
            return UIColor(hex: "998552")
        case .envelopeBackgroundYellow:
            return UIColor(hex: "E3DAC3")
        case .green:
            return UIColor(hex: "4BA651")
        case .lightGreen:
            return UIColor(hex: "E0EDE1")
        case .avokadoGreen:
            return UIColor(hex: "FEFFC8")
        case .metinGrisi:
            return UIColor(hex: "373737")
        case .metinGrisi2:
            return UIColor(hex: "353535")
        case .blueOpacity15:
            return UIColor(hex: "22A7F0")
        case .lightBlue:
            return UIColor(hex: "0DAACD")
        case .purpleEnvelope:
            return UIColor(hex: "9D9CEA")
        case .purpleOpacity15:
            return UIColor(hex: "7B5FED")
        case .purple2:
            return UIColor(hex: "6C63FF")
        case .lightOrange:
            return UIColor(hex: "FEE4C5")
        case .pembe:
            return UIColor(hex: "FAABED")
        case .koyuPembe:
            return UIColor(hex: "FF00E5")
        case .lightPembe:
            return UIColor(hex: "F587AC")
        case .letterTextColor:
            return UIColor(hex: "4F4325")
        case .letterSenderColor:
            return UIColor(hex: "837144")
        }
    }
}

// UIColor'u oluşturan yardımcı bir initializer
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}

enum CellColors {
    case green
    case purple
    case pink
    case orange
    case yellow
    case blue
    var colors: [UIColor] {
        switch self {
        case .green:
            return [UIColor(hex: "4BA651"), UIColor(hex: "4BA651").withAlphaComponent(0.15), UIColor(hex: "4BA651").withAlphaComponent(0.50)]
       case .purple:
            return [UIColor(hex: "7B5FED"), UIColor(hex: "7B5FED").withAlphaComponent(0.15), UIColor(hex: "7B5FED").withAlphaComponent(0.50)]
        case .orange:
            return [UIColor(hex: "FA6D27"), UIColor(hex: "FA6D27").withAlphaComponent(0.15), UIColor(hex: "FA6D27").withAlphaComponent(0.50)]
        case .pink:
            return [UIColor(hex: "F587AC"),UIColor(hex: "F587AC").withAlphaComponent(0.15),UIColor(hex: "F587AC").withAlphaComponent(0.50)]
        case .blue:
            return [UIColor(hex: "22A7F0"),UIColor(hex: "22A7F0").withAlphaComponent(0.15),UIColor(hex: "22A7F0").withAlphaComponent(0.50)]
        case .yellow:
            return [UIColor(hex: "F9CC4B"),UIColor(hex: "F9CC4B").withAlphaComponent(0.15),UIColor(hex: "F9CC4B").withAlphaComponent(0.50)]
        }
    }
    static func random() -> CellColors {
          let allValues: [CellColors] = [.green, .purple, .pink, .orange, .yellow, .blue]
          let randomIndex = Int(arc4random_uniform(UInt32(allValues.count)))
          return allValues[randomIndex]
      }
}


