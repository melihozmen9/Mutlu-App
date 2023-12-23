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
  
  var userType: UserType?
  
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
    v.textField.text = "melihv98@gmail.com"
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
  private lazy var refakatciLogin: loginTypeSquare = {
    let v = loginTypeSquare()
    v.imageview.image = UIImage(named: "refakatci")
    v.Lbl.text = "Ebeveyn"
    v.tag = 1
    return v
  }()
  
  private lazy var gonulluLogin: loginTypeSquare = {
    let v = loginTypeSquare()
    v.imageview.image = UIImage(named: "gonullu")
    v.Lbl.text = "Gönüllü"
    v.tag = 2
    return v
  }()
  
  private lazy var childLogin: loginTypeSquare = {
    let v = loginTypeSquare()
    v.imageview.image = UIImage(named: "gonullu2")
    v.Lbl.text = "Çocuk"
    v.tag = 2
    return v
  }()
  
  private lazy var typeLbl: UILabel = {
    let l = UILabel()
    l.font = Font.kohoRegular12.chooseFont
    l.textColor = CustomColor.lightGri.color
    l.textAlignment = .center
    l.text = "Üyelik tipini seçmen gerekiyor."
    return l
  }()
  
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
    tapGestureSignUp()
    configureTextFields()
    userType = nil
      
        updateLoginButtonState()
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
    
    let isUsernameEmpty = usernameTf.textField.text?.isEmpty ?? true
    let isPasswordEmpty = passwordTf.textField.text?.isEmpty ?? true
    
    let isValidUserType = userType != nil
        
        loginBtn.alpha = (isUsernameEmpty || isPasswordEmpty || !isValidUserType) ? 0.5 : 1.0
        loginBtn.isEnabled = !(isUsernameEmpty || isPasswordEmpty || !isValidUserType)
  }
  
 
  
  @objc func loginTapped() {
    let auth = Auth.auth()
    
    let email: String
       if userType == .child {
           email = usernameTf.textField.text! + "@mail.com"
       } else {
           email = usernameTf.textField.text!
       }
    
    if userType == .volunteer || userType == .parent {
           guard isValidEmail(email) else {
               let errorMessage = "Gönüllü veya Refakatçi girişi için geçerli bir e-posta adresi girmelisiniz."
               self.present(Service.createAlertController(title: "Hata", message: errorMessage), animated: true, completion: nil)
               return
           }
       }
    
    auth.signIn(withEmail: email, password: passwordTf.textField.text!) { (authResult, error) in
       if let error = error {
         self.present(Service.createAlertController(title: "OK", message: error.localizedDescription), animated: true, completion: nil)
         return
       }
      
      if let user = authResult?.user {
        let userID = user.uid
        print("User ID: \(userID)")
        
     
        let vc = MainTabBarController(userType: self.userType!, userID: userID )
    
        
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
  
  @objc func signUpTapped() {
    self.navigationController?.pushViewController(SignUpVC (), animated: true)
  }
  
  @objc private func refakatciTapped() {
      userType = .parent
      updateSelectedLoginType(refakatciLogin)
    updateUsernamePlaceholder(for: .parent)
    infoLbl.isHidden = false
  }

  @objc private func gonulluTapped() {
      userType = .volunteer
      updateSelectedLoginType(gonulluLogin)
    updateUsernamePlaceholder(for: .volunteer)
    infoLbl.isHidden = false
  }

  @objc private func childTapped() {
      userType = .child
      updateSelectedLoginType(childLogin)
    updateUsernamePlaceholder(for: .child)
    infoLbl.isHidden = true
  }
  private func isValidEmail(_ email: String?) -> Bool {
      guard let email = email else { return false }
      return email.contains("@") && email.contains(".")
  }

  private func updateSelectedLoginType(_ selectedTypeView: loginTypeSquare) {
      // Tüm loginTypeSquare'leri varsayılan durumlarına getir
      refakatciLogin.setBorder(color: CustomColor.lightGri2.color)
      gonulluLogin.setBorder(color: CustomColor.lightGri2.color)
      childLogin.setBorder(color: CustomColor.lightGri2.color)

      // Seçilen loginTypeSquare'e sarı kenarlık ekle
      selectedTypeView.setBorder(color: CustomColor.anaSarı.color)
    updateLoginButtonState()
  }
  private func updateUsernamePlaceholder(for userType: UserType) {
     // Kullanıcı tipine bağlı olarak placeholder'ı güncelle
     switch userType {
     case .parent, .volunteer:
       usernameTf.textField.attributedPlaceholder = NSAttributedString(string: "E-posta adresin", attributes: usernameTf.attributes)
     case .child:
       usernameTf.textField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: usernameTf.attributes)
     }
   }
  
  private func setupView() {
    self.navigationItem.setHidesBackButton(true, animated: true)
    view.backgroundColor = CustomColor.beyaz.color
    view.addSubViews(topImageview,welcomeLbl,usernameTf,passwordTf,loginBtn,forgotBtn, childLogin, gonulluLogin, refakatciLogin, typeLbl, signUpLbl,infoLbl,singUpBtn)
    infoLbl.isHidden = true
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
    refakatciLogin.snp.makeConstraints { make in
      make.top.equalTo(passwordTf.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(60)
      make.width.equalTo(80)
      make.height.equalTo(60)
    }
    childLogin.snp.makeConstraints { make in
      make.top.equalTo(passwordTf.snp.bottom).offset(20)
      make.leading.equalTo(refakatciLogin.snp.trailing).offset(20)
      make.width.equalTo(80)
      make.height.equalTo(60)
    }
    gonulluLogin.snp.makeConstraints { make in
      make.top.equalTo(passwordTf.snp.bottom).offset(20)
      make.leading.equalTo(childLogin.snp.trailing).offset(20)
      make.width.equalTo(80)
      make.height.equalTo(60)
    }
    typeLbl.snp.makeConstraints { make in
      make.centerY.equalTo(refakatciLogin.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(10)
      make.trailing.equalToSuperview().offset(-20)
    }
        infoLbl.snp.makeConstraints { make in
          make.top.equalTo(typeLbl.snp.bottom).offset(10)
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
        forgotBtn.snp.makeConstraints { make in
          make.top.equalTo(loginBtn.snp.bottom).offset(19)
          make.trailing.equalToSuperview().offset(-20)
          make.width.equalTo(87)
          make.height.equalTo(8)
        }
  
    
    
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
  
      private func tapGestureSignUp() {
          let refakatciTapGesture = UITapGestureRecognizer(target: self, action: #selector(refakatciTapped))
          refakatciLogin.addGestureRecognizer(refakatciTapGesture)
          refakatciLogin.isUserInteractionEnabled = true
  
          let gonulluTapGesture = UITapGestureRecognizer(target: self, action: #selector(gonulluTapped))
          gonulluLogin.addGestureRecognizer(gonulluTapGesture)
          gonulluLogin.isUserInteractionEnabled = true
        
        let childTapGesture = UITapGestureRecognizer(target: self, action: #selector(childTapped))
        childLogin.addGestureRecognizer(childTapGesture)
        childLogin.isUserInteractionEnabled = true
      }
  
}
