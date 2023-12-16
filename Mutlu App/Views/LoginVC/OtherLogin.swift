//
//  SignUpVC.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import Firebase

class OtherLoginVC: UIViewController {
    
    var userType: UserType?
    
    private lazy var topImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "duckSleep")
        return iv
    }()

    private lazy var emailTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: v.attributes)
        v.textField.text = "melihv3@gmail.com"
        return v
    }()
    
    private lazy var passwordTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Şifren", attributes: v.attributes)
        v.imageview.image = UIImage(named: "hide")
        v.textField.text = "123456"
        return v
    }()
    
    private lazy var loginBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Giriş Yap", for: .normal)
        btn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func loginTapped() {
        let auth = Auth.auth()
        
        auth.signIn(withEmail: emailTf.textField.text!, password: passwordTf.textField.text!) { (authResult, error) in
            if let error = error {
                self.present(Service.createAlertController(title: "OK", message: error.localizedDescription), animated: true, completion: nil)
                return
            }
            
            if let user = authResult?.user {
                let userID = user.uid
                print("User ID: \(userID)")
                
                // Oturum açma başarılıysa, istediğiniz işlemleri gerçekleştirebilirsiniz.
                let vc = MainPageVC()
                vc.userType = self.userType
                vc.userID = userID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(topImageview, emailTf,passwordTf, loginBtn)
        setupLayout()
    }
    private func setupLayout() {
        topImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(135)
            make.trailing.equalToSuperview().offset(-135)
            make.height.equalTo(120)
        }
        emailTf.snp.makeConstraints { make in
            make.top.equalTo(topImageview.snp.bottom).offset(55)
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
        loginBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
    }

}
