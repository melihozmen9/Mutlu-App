//
//  CustomTF.swift
//  Mutlu App
//
//  Created by Kullanici on 7.11.2023.
//

import UIKit

enum SideView {
    case left(image:UIImage)// case'in içine parametere verebiliyoruz.
    case right(image:UIImage)
    case none
  
    
    var defineSideView:UIView? {// computed property. UIview tipinde bir dewğişken. birşeyler hesalandıktan sonra buna atanacak. return ile buna atanacak.
        switch self {// neden self diyorum. çünkü enum içindeyiz.
        case .left(let image):// dıaşrdan alacagımıız veriyi sabite at. ve o sabiti kullan diyor.
            return setSideView(icon: image)//Enum içinde fonmksiyon kullanımı. return değeri olan bir değer.
        case .right(let image):
            return setSideView(icon: image)
        case .none:
            return nil
        }
    }
    
    
    func setSideView(icon:UIImage? = nil) -> UIView{
        let imageView = UIImageView(frame: CGRect(x: 4, y: 0, width: 22, height: 22))
        imageView.image = icon // parametre oalrak image aldık. view donduruyoruz.
        imageView.contentMode = .scaleAspectFit
        
        let sideView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 22))
        sideView.addSubview(imageView)
        
        return sideView
    }
}


class CustomTF: UITextField {
    
    var insets: UIEdgeInsets
    
    var sideView:SideView? = nil {//başlangıçta il. alsın. boş gelisn.
            didSet{
                defineSideViewLocation()
            }
        }
    
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: CustomColor.lightGri.color,
        .font: UIFont(name: "Koho-Medium", size: 16)!
    ]
   
    init(insets:UIEdgeInsets = UIEdgeInsets(top:0,left:10,bottom: 0,right:12)){
          self.insets = insets
          super.init(frame: .zero)
        self.font = Font.kohoMedium16.chooseFont
        self.backgroundColor = CustomColor.attributedWhite.color
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = CustomColor.lightGri2.color.cgColor
    }
    
    func defineSideViewLocation() { //left ise leftView'a ekle. irghtise RightView'a ekle.
            
            switch sideView {
            case .left(let image):
                self.leftView = sideView?.defineSideView
                self.leftViewMode = .always
            case .right(let image):
                self.rightView = sideView?.defineSideView
                self.rightViewMode = .always
            case .none:
                return
           default :
                return
            }
            
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

