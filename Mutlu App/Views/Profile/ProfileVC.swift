//
//  ProfileVC.swift
//  Mutlu App
//
//  Created by Kullanici on 12.12.2023.
//


//MARK: - Bu sayfa çalıştıgında userType ve imageURL bilgisi anasayfadan gelecek.

import UIKit

class ProfileVC: UIViewController, PhotoChanger {

    
    var profilePicture: String? = "empty"
    var userType: UserType? = nil
    
    var sectionTitles = ["Bilgilerim","Ayarlar","Kaynakça"]
    
    private lazy var topImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "choosePhoto")
        iv.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topImageviewTapped))
        iv.addGestureRecognizer(tapGesture)
        iv.isUserInteractionEnabled = true
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @objc func topImageviewTapped() {
 
        let vc = PhotoPickerVC()
        vc.delegate = self
        vc.userType = userType
        present(vc, animated: true, completion: nil)
    }
    
    func changePhoto(imageURL: URL) {
        topImageview.kf.setImage(with: imageURL)
        profilePicture = imageURL.absoluteString
        //TODO: - realtimedatabse'deki usertype'a göre belirlenen database'deki userID'yi bulacak ve onun profilePicture ozelliğini "set" edecek.
    }

    private func setupView() {
        
        setupLayout()
    }
    private func setupLayout() {
        
    }
}
