//
//  VolunteerSignUpVC.swift
//  Mutlu App
//
//  Created by Kullanici on 19.08.2023.
//

import UIKit
import TinyConstraints
import Firebase
class VolunteerSignUpVC: UIViewController {
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    private lazy var nameTf: CustomTextField = {
        let tf = CustomTextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: tf.attributes)
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var passwordTf: CustomTextField = {
        let tf = CustomTextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: tf.attributes)
        
        return tf
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Kayıt Ol"
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
        label.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        label.frame.size.width = 40
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        button.layer.cornerRadius = 10.0
        button.frame.size.width = 40
        button.setTitle("kayıt ol", for: .normal)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

    @objc func signUpTapped1(_ sender: UITapGestureRecognizer) {
        let auth = Auth.auth()
        guard let name = nameTf.text, let password = passwordTf.text else { return }
        
        auth.createUser(withEmail: (name + "@gmail.com"), password: password) { (authResult, error) in
            if let error = error {
                self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
            } else if let user = authResult?.user {
                let userID = user.uid  // Kullanıcının UID'si
                
                let databaseRef = Database.database().reference()
                
                // Volunteers verilerini ekleyin
                let volunteersData: [String: Any] = [
                    "name": name,
                    "userID": userID,
                    "count": 0,
                    "type" : "volunteer"
                ]
                
                // Volunteers düğümü altına verileri ekle
                databaseRef.child("volunteers").childByAutoId().setValue(volunteersData) { (error, ref) in
                    if let error = error {
                        print("Error writing volunteers data to Realtime Database: \(error)")
                    } else {
                        print("Volunteers data written to Realtime Database successfully.")
                        
                        // Ana sayfaya yönlendirme
                        let mainViewController = UINavigationController(rootViewController: MainViewController())
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        self.present(mainViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = view.frame.size.height * 0.03
        sv.distribution = .fillEqually
        return sv
    }()
    
//    private func createBackButton() -> UIBarButtonItem {
//        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain , target: self, action: #selector(backButtonTapped))
//        button.tintColor = .systemPink
//        return button
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
        setupLabelTap()
    }
    
    @objc func signUpTapped() {
        
        let auth = Auth.auth()
        guard let name = nameTf.text, let password = passwordTf.text else { return }
        
        auth.createUser(withEmail: (name + "@gmail.com"), password: password) { (authResult, error) in
            if let error = error {
                self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
            } else if let user = authResult?.user {
                let userID = user.uid  // Kullanıcının UID'si
                
                let databaseRef = Database.database().reference()
                
                // Volunteers verilerini ekleyin
                let volunteersData: [String: Any] = [
                    "name": name,
                    "userID": userID,
                    "count": 0
                ]
                
                // Volunteers düğümü altına verileri ekle
                databaseRef.child("volunteers").childByAutoId().setValue(volunteersData) { (error, ref) in
                    if let error = error {
                        print("Error writing volunteers data to Realtime Database: \(error)")
                    } else {
                        print("Volunteers data written to Realtime Database successfully.")
                        
                        // Ana sayfaya yönlendirme
                        let mainViewController = UINavigationController(rootViewController: MainViewController())
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        self.present(mainViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func setupLabelTap() {
        
        let signUpLabel = UITapGestureRecognizer(target: self, action: #selector(signUpTapped1(_:)))
        self.signUpLabel.isUserInteractionEnabled = true
        self.signUpLabel.addGestureRecognizer(signUpLabel)
    }

    private func setupView() {
        view.addSubViews(stackView,signUpLabel)
        stackView.addArrangedSubview(nameTf)
        stackView.addArrangedSubview(passwordTf)
        design()
        setupLayout()
    }
    
    private func design() {
        title = "Gönüllü Kayıt Sayfası"
         //navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleToFill
         backgroundImageView.alpha = 0.1
         backgroundImageView = UIImageView(image: backgroundImage)
         view.insertSubview(backgroundImageView, at: 0)
    }
    
    private func setupLayout() {
        stackView.edgesToSuperview(excluding: [.bottom], insets: .top(view.frame.size.height * 0.05)
                                    +       .left(view.frame.size.width * 0.2)
                                    +       .right(view.frame.size.width * 0.2)
                                    ,  usingSafeArea: true)
        stackView.height(view.frame.size.height * 0.23)
        
        
        signUpLabel.edgesToSuperview(excluding: [.top, .bottom], insets: .left(view.frame.size.width * 0.38) + .right(view.frame.size.width * 0.38))
        signUpLabel.height(view.frame.size.height * 0.07)
        signUpLabel.topToBottom(of: stackView, offset: view.frame.size.height * 0.05)
    }
    
    
    
//    lazy var backButton: UIBarButtonItem = {
//        return createBackButton()
//    }()
//
//
//
//
//    @objc private func backButtonTapped() {
//     dismiss(animated: true, completion: nil)
//    }
 

}
