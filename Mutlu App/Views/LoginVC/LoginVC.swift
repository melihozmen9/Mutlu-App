//
//  LoginVC.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import SnapKit
import Firebase

class LoginVC: UIViewController {
    
    private lazy var topImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "duckSleep")
        return iv
    }()
    
    private lazy var welcomeLbl: UILabel = {
        let l = UILabel()
        l.text = "Hoş Geldin!"
        l.font = Font.kohoSemibold32.chooseFont
        l.textColor = CustomColor.anaSarı.color
        return l
    }()
    
    private lazy var usernameTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: v.attributes)
        v.textField.text = "melihc99"
        return v
    }()
    
    private lazy var passwordTf: CstmTextField = {
        let v = CstmTextField()
        v.textField.attributedPlaceholder = NSAttributedString(string: "Şifren", attributes: v.attributes)
        v.imageview.image = UIImage(named: "hide")
        v.textField.text = "123456"
        return v
    }()
    
    private lazy var forgotBtn: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "Şifremi Unuttum",
                                                  attributes: [
            .foregroundColor: CustomColor.anaSarı.color,
            .font: UIFont(name: "Koho-Medium", size: 12)!]), for: .normal)
//        btn.addTarget(self, action: #selector(), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loginBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Giriş Yap", for: .normal)
        btn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        btn.alpha = 0.5
                btn.isEnabled = false
        return btn
    }()
    
    private lazy var infoLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoRegular12.chooseFont
        l.textColor = CustomColor.lightGri.color
        l.textAlignment = .center
        l.text = "Gönüllü ya da Refakatçi girişi için email girmelisiniz."
        return l
    }()
    
//    private lazy var lineView1: UIView = {
//        let v = UIView()
//        v.backgroundColor = CustomColor.gri.color
//        return v
//    }()
//
//    private lazy var lineView2: UIView = {
//        let v = UIView()
//        v.backgroundColor = CustomColor.gri.color
//        return v
//    }()
//
//    private lazy var orLbl: UILabel = {
//        let l = UILabel()
//        l.text = "veya"
//        l.font = Font.urbanMedium16.chooseFont
//        l.textColor = CustomColor.gri2.color
//        l.textAlignment = .center
//        return l
//    }()
//
//    private lazy var refakatciLogin: loginTypeSquare = {
//        let v = loginTypeSquare()
//        v.imageview.image = UIImage(named: "refakatci")
//        v.Lbl.text = "Ebeveyn"
//        v.tag = 1
//        return v
//    }()
//
//    private lazy var gonulluLogin: loginTypeSquare = {
//        let v = loginTypeSquare()
//        v.imageview.image = UIImage(named: "gonullu")
//        v.Lbl.text = "Gönüllü"
//        v.tag = 2
//        return v
//    }()
    
    private lazy var signUpLbl: UILabel = {
        let l = UILabel()
        l.text = "Hesabın yok mu?"
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.gri2.color
        return l
    }()
    
    private lazy var singUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Hesap oluştur", for: .normal)
        btn.setTitleColor(CustomColor.anaSarı.color, for: .normal)
        btn.titleLabel?.font = Font.kohoSemiBold18.chooseFont
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //tapGestureSignUp()
        configureTextFields()
    }
    private func configureTextFields() {
          // TextField dinleme ekleyin
          usernameTf.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
          passwordTf.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      }

      @objc private func textFieldDidChange(_ textField: UITextField) {
          // TextField değeri değiştiğinde kontrol et
          updateLoginButtonState()
      }
   

      private func updateLoginButtonState() {
          // Username ve password boş değilse ve username bir email değilse
          let isUsernameEmpty = usernameTf.textField.text?.isEmpty ?? true
          let isPasswordEmpty = passwordTf.textField.text?.isEmpty ?? true
          //let isValidUsername = isValidEmail(usernameTf.textField.text)

          // Opacity ve tıklanabilirlik durumunu güncelle
          loginBtn.alpha = (isUsernameEmpty || isPasswordEmpty) ? 0.5 : 1.0
          loginBtn.isEnabled = !(isUsernameEmpty || isPasswordEmpty)
      }

      private func isValidEmail(_ email: String?) -> Bool {
          guard let email = email else { return false }
          return email.contains("@") && email.contains(".")
      }
    
    @objc func loginTapped() {
        let auth = Auth.auth()
        
        auth.signIn(withEmail: usernameTf.textField.text! + "@gmail.com", password: passwordTf.textField.text!) { (authResult, error) in
            if let error = error {
                self.present(Service.createAlertController(title: "OK", message: error.localizedDescription), animated: true, completion: nil)
                return
            }
            
            if let user = authResult?.user {
                let userID = user.uid
                print("User ID: \(userID)")
                
                // Oturum açma başarılıysa, istediğiniz işlemleri gerçekleştirebilirsiniz.
                let vc = MainPageVC()
//                vc.userType = !self.isValidEmail(self.usernameTf.textField.text) ? .child : nil
                vc.userType = .child
                vc.userID = userID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func signUpTapped() {
         self.navigationController?.pushViewController(SignUpVC (), animated: true)
     }
    
    @objc private func refakatciTapped() {
        let vc = OtherLoginVC()
        vc.userType = .parent
        vc.navigationItem.title = "Refakatçi Giriş"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func gonulluTapped() {
        let vc = OtherLoginVC()
        vc.userType = .volunteer
        vc.navigationItem.title = "Gönüllü Giriş"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = CustomColor.beyaz.color
        view.addSubViews(topImageview,welcomeLbl,usernameTf,passwordTf,loginBtn,forgotBtn,signUpLbl,infoLbl,singUpBtn)
        setupLayout()
    }
    
    private func setupLayout() {
        topImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77)
            make.leading.equalToSuperview().offset(64)
            make.trailing.equalToSuperview().offset(-64)
            make.height.equalTo(168)
        }
        welcomeLbl.snp.makeConstraints { make in
            make.top.equalTo(topImageview.snp.bottom).offset(38)
            make.leading.equalToSuperview().offset(110)
            make.trailing.equalToSuperview().offset(-110)
            make.height.equalTo(22)
        }
        usernameTf.snp.makeConstraints { make in
            make.top.equalTo(welcomeLbl.snp.bottom).offset(34)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        passwordTf.snp.makeConstraints { make in
            make.top.equalTo(usernameTf.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        forgotBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTf.snp.bottom).offset(19)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(87)
            make.height.equalTo(8)
        }
        infoLbl.snp.makeConstraints { make in
            make.top.equalTo(forgotBtn.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(10)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(infoLbl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
//        lineView1.snp.makeConstraints { make in
//            make.top.equalTo(loginBtn.snp.bottom).offset(38)
//            make.leading.equalToSuperview().offset(20)
//            make.width.equalTo(135)
//            make.height.equalTo(1)
//        }
//        orLbl.snp.makeConstraints { make in
//            make.top.equalTo(loginBtn.snp.bottom).offset(28)
//            make.leading.equalTo(lineView1.snp.trailing).offset(23)
//            make.height.equalTo(20)
//        }
//        lineView2.snp.makeConstraints { make in
//            make.top.equalTo(loginBtn.snp.bottom).offset(38)
//            make.leading.equalTo(orLbl.snp.trailing).offset(23)
//            make.width.equalTo(135)
//            make.height.equalTo(1)
//            make.trailing.equalToSuperview().offset(-20)
//        }
//        refakatciLogin.snp.makeConstraints { make in
//            make.top.equalTo(orLbl.snp.bottom).offset(40)
//            make.leading.equalToSuperview().offset(105)
//            make.width.equalTo(80)
//            make.height.equalTo(60)
//        }
//        gonulluLogin.snp.makeConstraints { make in
//            make.top.equalTo(orLbl.snp.bottom).offset(40)
//            make.leading.equalTo(refakatciLogin.snp.trailing).offset(20)
//            make.width.equalTo(80)
//            make.height.equalTo(60)
//        }
        signUpLbl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(98)
            make.trailing.equalTo(singUpBtn.snp.leading)
            make.bottom.equalToSuperview().offset(-42)
        }
        singUpBtn.snp.makeConstraints { make in
            make.centerY.equalTo(signUpLbl.snp.centerY)
            make.leading.equalTo(signUpLbl.snp.trailing)
            make.height.equalTo(10)
            make.trailing.equalToSuperview().offset(-70)
        }
    }

//    private func tapGestureSignUp() {
//        let refakatciTapGesture = UITapGestureRecognizer(target: self, action: #selector(refakatciTapped))
//        refakatciLogin.addGestureRecognizer(refakatciTapGesture)
//        refakatciLogin.isUserInteractionEnabled = true
//
//        let gonulluTapGesture = UITapGestureRecognizer(target: self, action: #selector(gonulluTapped))
//        gonulluLogin.addGestureRecognizer(gonulluTapGesture)
//        gonulluLogin.isUserInteractionEnabled = true
//    }

}
