//
//  SignUpVC.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher

class OtherSignUpVC: UIViewController, PhotoChanger {
    
    var userType: UserType?
    var profilePicture: String? = ""
    
    private lazy var topImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "choosePhoto")
        iv.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topImageviewTapped))
        iv.addGestureRecognizer(tapGesture)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var usernameTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: v.attributes)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func signUpTapped() {
        let auth = Auth.auth()
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
                        "type" : self.userType?.rawValue
                    ]
                    
                    switch self.userType {
                    case .volunteer:
                        databaseRef.child(DataCategory.volunteers.rawValue).childByAutoId().setValue(userData) { (error, ref) in
                            if let error = error {
                                print("Error writing volunteers data to Realtime Database: \(error)")
                            } else {
                                print("Volunteers data written to Realtime Database successfully.")
                                vc.userType = self.userType
                                vc.userID = userID
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    case .parent:
                        databaseRef.child(DataCategory.parents.rawValue).childByAutoId().setValue(userData) { (error, ref) in
                            if let error = error {
                                print("Error writing volunteers data to Realtime Database: \(error)")
                            } else {
                                print("Volunteers data written to Realtime Database successfully.")
                                vc.userType = self.userType
                                vc.userID = userID
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    case .child:
                        break
                    case .none:
                        break
                    }
                }
            }
        }
    }
    
    
    @objc func topImageviewTapped() {
        let vc = PhotoPickerVC()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func changePhoto(imageURL: URL) {
        topImageview.kf.setImage(with: imageURL)
        profilePicture = imageURL.absoluteString
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(topImageview, usernameTf, emailTf,passwordTf,confirmPasswordTf, signUpBtn)
        setupLayout()
    }
    private func setupLayout() {
        topImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(135)
            make.trailing.equalToSuperview().offset(-135)
            make.height.equalTo(120)
        }
        usernameTf.snp.makeConstraints { make in
            make.top.equalTo(topImageview.snp.bottom).offset(55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
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
        confirmPasswordTf.snp.makeConstraints { make in
            make.top.equalTo(passwordTf.snp.bottom).offset(20)
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
    
}
