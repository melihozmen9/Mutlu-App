//
//  SignUpVC.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import Firebase
import Kingfisher

protocol PhotoChanger: AnyObject {
    func changePhoto(imageURL:URL)
}

class SignUpVC: UIViewController, PhotoChanger {
    
    var profilePicture: String? = "empty"
    var userType = UserType.child
    
    var menuTitle = ["Çocuk", "Gönüllü", "Refakatçi"]
    
    private lazy var topImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "choosePhoto")
        iv.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topImageviewTapped))
        iv.addGestureRecognizer(tapGesture)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var infoLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoRegular12.chooseFont
        l.textColor = CustomColor.lightGri.color
        l.textAlignment = .center
        l.text = "Görsel seçebilmen için yaşını girmen gerekli"
        return l
    }()
    
    private lazy var usernameTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: v.attributes)
        return v
    }()
    
    private lazy var ageTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Yaşın", attributes: v.attributes)
        return v
    }()
    
    private lazy var emailTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "ornek@email.com", attributes: v.attributes)
        return v
    }()
    
    private lazy var passwordTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Şifren", attributes: v.attributes)
        v.imageview.image = UIImage(named: "hide")
        return v
    }()
    
    private lazy var confirmPasswordTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Şifren", attributes: v.attributes)
        v.imageview.image = UIImage(named: "hide")
        return v
    }()

    private lazy var signUpBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Devam Et", for: .normal)
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var dropdownView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColor.anaSarı.color.cgColor
        view.backgroundColor = CustomColor.anaSarı.color.withAlphaComponent(0.15)
        view.layer.cornerRadius = 28

        let selectedTitle = menuTitle.first ?? ""
       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 100
        // Metin
        let attributedString = NSAttributedString(string: selectedTitle, attributes: [
            NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
            NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
        ])
        let label = UILabel()
        label.attributedText = attributedString

        stackView.addArrangedSubview(label)

        // Aşağı yönlü ok görseli
        let arrowImage = UIImage(systemName: "chevron.down")
        let arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.tintColor = CustomColor.anaSarı.color

        stackView.addArrangedSubview(arrowImageView)


        view.addSubview(stackView)
        

        // StackView'a constraint'leri ayarla
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }

        // UIView'a dokunma tanımla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownViewTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func dropdownViewTapped() {
        showDropdownMenu()
    }

    func showDropdownMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for title in menuTitle {
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.handleDropdownSelection(title)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let presentationController = alertController.popoverPresentationController {
            presentationController.sourceView = dropdownView
            presentationController.sourceRect = dropdownView.bounds
        }

        present(alertController, animated: true, completion: nil)
    }

    func handleDropdownSelection(_ selectedTitle: String) {
        updateDropdownViewTitle(selectedTitle)
        
        if userType == .child {
            ageTf.isHidden = false
            emailTf.isHidden = true
            ageTf.snp.remakeConstraints { make in
                make.top.equalTo(usernameTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
        } else {
            ageTf.isHidden = true
            emailTf.isHidden = false
            emailTf.snp.remakeConstraints { make in
                make.top.equalTo(usernameTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
        }
        
        view.layoutIfNeeded()
    }

    func updateDropdownViewTitle(_ selectedTitle: String) {
        setType(value: selectedTitle)
        if let stackView = dropdownView.subviews.first as? UIStackView,
            let label = stackView.arrangedSubviews.first as? UILabel {

            let attributedString = NSAttributedString(string: selectedTitle, attributes: [
                NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
                NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
            ])
            label.attributedText = attributedString
        }
    }
    
    private func setType(value: String) {

        switch value {
        case "Çocuk":
            userType = .child
        case "Gönüllü":
            userType = .volunteer
        case "Refakatçi":
            userType = .parent
      
        default:
            break
        }
      
    }
    
    @objc func signUpTapped() {
        let auth = Auth.auth()
        
        switch userType {
        case .child:
            guard let name = usernameTf.textField.text, let age = ageTf.textField.text, let password1 = passwordTf.textField.text, let password2 = confirmPasswordTf.textField.text else { return }
            if password1 == password2 {
            if isAgeInRange(age) {
                if password1 == password2 {
                    auth.createUser(withEmail: (name + "@gmail.com"), password: password1) { (authResult, error) in
                        if let error = error {
                            self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                        } else if let user = authResult?.user {
                            let userID = user.uid  // Kullanıcının UID'si
                            
                            let databaseRef = Database.database().reference()
                            
                            // Volunteers verilerini ekleyin
                            let childrenData: [String: Any] = [
                                "name": name,
                                "age": age,
                                "profilePicture": self.profilePicture,
                                "count": 0,
                                "type" : "child"
                            ]
                            
                            databaseRef.child("children").child(userID).setValue(childrenData) { (error, ref) in
                                if let error = error {
                                    print("Error writing volunteers data to Realtime Database: \(error)")
                                } else {
                                    let vc = MainPageVC()
                                    vc.userType = .child
                                    vc.userID = userID
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            }
        case .volunteer:
            guard let name = usernameTf.textField.text,  let email = emailTf.textField.text, let password1 = passwordTf.textField.text, let password2 = confirmPasswordTf.textField.text else { return }
            if password1 == password2 {
            auth.createUser(withEmail: email, password: password1) { (authResult, error) in
                if let error = error {
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                } else if let user = authResult?.user {
                    let userID = user.uid
                    
                    let databaseRef = Database.database().reference()
                    let vc = MainPageVC()
                    vc.userType = self.userType
                    
                    
                    let userData: [String: Any] = [
                        "name": name,
                        "profilPicture": self.profilePicture,
                        "email": email,
                        "type" : self.userType.rawValue
                    ]
                    databaseRef.child(DataCategory.volunteers.rawValue).child(userID).setValue(userData) { (error, ref) in
                        if let error = error {
                            print("Error writing volunteers data to Realtime Database: \(error)")
                        } else {
                        
                            vc.userType = self.userType
                            vc.userID = userID
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            }
        case .parent:
            guard let name = usernameTf.textField.text,  let email = emailTf.textField.text, let password1 = passwordTf.textField.text, let password2 = confirmPasswordTf.textField.text else { return }
            if password1 == password2 {
            auth.createUser(withEmail: email, password: password1) { (authResult, error) in
                if let error = error {
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                } else if let user = authResult?.user {
                    let userID = user.uid
                    
                    let databaseRef = Database.database().reference()
                    let vc = MainPageVC()
                    vc.userType = self.userType
                    
                    
                    let userData: [String: Any] = [
                        "name": name,
                        "profil": self.profilePicture,
                        "email": email,
                        "userID": userID,
                        "count": 0,
                        "type" : self.userType.rawValue
                    ]
                    databaseRef.child(DataCategory.parents.rawValue).child(userID).setValue(userData) { (error, ref) in
                        if let error = error {
                            print("Error writing volunteers data to Realtime Database: \(error)")
                        } else {
                        
                            vc.userType = self.userType
                            vc.userID = userID
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            }
      
      
        }
    }
    

    
    @objc func topImageviewTapped() {
        guard let ageText = ageTf.textField.text, !ageText.isEmpty else { return }
        let vc = PhotoPickerVC()
        vc.delegate = self
        vc.userType = userType
        present(vc, animated: true, completion: nil)
    }
    
    func changePhoto(imageURL: URL) {
        topImageview.kf.setImage(with: imageURL)
        profilePicture = imageURL.absoluteString
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(topImageview, infoLbl, usernameTf, ageTf ,passwordTf,confirmPasswordTf, signUpBtn, emailTf, dropdownView)
        setupLayout()
    }
    private func setupLayout() {
        topImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(135)
            make.trailing.equalToSuperview().offset(-135)
            make.height.equalTo(120)
        }
        infoLbl.snp.makeConstraints { make in
            make.top.equalTo(topImageview.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(10)
        }
        usernameTf.snp.makeConstraints { make in
            make.top.equalTo(infoLbl.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        if userType == .child {
            ageTf.snp.makeConstraints { make in
                make.top.equalTo(usernameTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
            passwordTf.snp.makeConstraints { make in
                make.top.equalTo(ageTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
        } else {
    
            emailTf.snp.makeConstraints { make in
                make.top.equalTo(usernameTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
            passwordTf.snp.makeConstraints { make in
                make.top.equalTo(emailTf.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(55)
            }
        }
       
        confirmPasswordTf.snp.makeConstraints { make in
            make.top.equalTo(passwordTf.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        dropdownView.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTf.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        signUpBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
    }
    
    func isAgeInRange(_ text: String) -> Bool {
        if let age = Int(text) {
            return (7...18).contains(age)
        }
        return false
    }
    
}
