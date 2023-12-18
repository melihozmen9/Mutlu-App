//
//  LetterWriteVC.swift
//  Mutlu App
//
//  Created by Kullanici on 3.12.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class LetterWriteVC: UIViewController, UITextViewDelegate {
    
    var penpalIDKey: String?
    var userType: UserType?
    var toWhom: String?
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "paper")
        return iv
    }()

    private lazy var toLbl: UILabel = {
        let l = UILabel()
        l.font = Font.vollkornSemibold18.chooseFont
        l.textColor = CustomColor.letterSenderColor.color
        l.text = "Gönderilen:"
        return l
    }()
    
    private lazy var toWhomLbl: UILabel = {
        let l = UILabel()
        l.font = Font.vollkornBold18.chooseFont
        l.textColor = CustomColor.letterTextColor.color
        l.text = toWhom ?? ""
        return l
    }()
    
    private lazy var letterTextview: UITextView = {
        let tv = UITextView()
        tv.font = Font.vollkornMedium15.chooseFont
        tv.textColor = CustomColor.letterTextColor.color
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.text = "Yazmak için buraya dokun..."
        tv.textColor = .lightGray
        tv.font = UIFont(name: "Kalam-Regular", size: 18)
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
    }
    
   
    
    private func setupView() {
        view.backgroundColor = CustomColor.attributedWhite.color
        view.addSubViews(imageview)
        view.insertSubview(letterTextview, aboveSubview: imageview)
        imageview.addSubViews(toWhomLbl,toLbl)
        setupNavigationBar()
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-102)
        }
        toLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalToSuperview().offset(26)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        toWhomLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalTo(toLbl.snp.trailing).offset(3)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        letterTextview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(243)
            make.leading.equalToSuperview().offset(47)
            make.trailing.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-153)
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Mektup Yaz"
        let imageButton = UIBarButtonItem(
                   image: UIImage(named: "send"),
                   style: .plain,
                   target: self,
                   action: #selector(sendTapped)
               )
               self.navigationItem.rightBarButtonItem = imageButton
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == "Yazmak için buraya dokun..." {
               textView.text = ""
               textView.textColor = CustomColor.letterTextColor.color
               textView.font = Font.vollkornMedium15.chooseFont
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Yazmak için buraya dokun..."
               textView.textColor = .lightGray
           }
       }
  
  func getFCMToken(completion: @escaping (String?) -> Void) {
      Messaging.messaging().token(completion: { token, error in
          if let error = error {
              print("FCM token alınamadı: \(error.localizedDescription)")
              completion(nil)
          } else if let token = token {
              print("FCM token başarıyla alındı: \(token)")
              completion(token)
          }
      })
  }

    @objc func sendTapped() {
        print("butona baısldı")
        if let text = letterTextview.text {
            let formatter = DateFormatter()
            let locale = Locale(identifier: "tr_TR")
            formatter.locale = locale
            formatter.dateFormat = "dd MMMM yyyy, EEEE"
            let dateString = formatter.string(from: Date())
            print(dateString)
            let lettersData: [String: Any] = [
                   "text": text,
                   "date": dateString,
                   "sender": userType?.rawValue,
                   "isFiltered" : false
               ]
            let dateData: [String:String] = [
                "lastDate": dateString
            ]
          
          getFCMToken { token in
         
            guard let token = token else {return}
            let databaseRef = Database.database().reference()
            
            guard let penpalIDKey = self.penpalIDKey else {return }
            print(penpalIDKey)
            let newPenpalsRef = databaseRef.child("penpals").child(penpalIDKey)
            newPenpalsRef.updateChildValues(dateData)
           
            if self.userType == .child {
                      let childDeviceData: [String:String] = [
                                    "childDeviceID": token
                                ]
                                newPenpalsRef.updateChildValues(childDeviceData)
            } else {
              
                    let volunteerDeviceData: [String:String] = [
                                  "volunteerDeviceID": token
                              ]
                              newPenpalsRef.updateChildValues(volunteerDeviceData)
                      }
            let newLetterRef = newPenpalsRef.child("letters").childByAutoId() // selectedPenpalsID, güncellenmek istenen penpals verisinin ID'si olmalı
            newLetterRef.setValue(lettersData) { (error, ref) in
                if let error = error {
                    print("Error adding letter data: \(error.localizedDescription)")
                } else {
                    print("Letter data added successfully.")
                }
            }
            //burada sıfırdan instance alabilir. dikkat et.
            if let viewControllers = self.navigationController?.viewControllers {
                if viewControllers.count >= 3 {
                    let targetViewController = viewControllers[viewControllers.count - 3]
                    self.navigationController?.popToViewController(targetViewController, animated: true)
                }
            }
            
          }
        }
    }
    
}
