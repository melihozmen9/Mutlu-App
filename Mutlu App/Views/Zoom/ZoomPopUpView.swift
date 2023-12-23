//
//  ZoomPopUpView.swift
//  Mutlu App
//
//  Created by Kullanici on 3.12.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging


class ZoomPopUpVC: UIViewController {
    
    var userID: String?
    
    private lazy var view1: UIView = {
        let v = UIView()
        v.backgroundColor = CustomColor.lightGreen.color
        v.layer.borderWidth = 2
        v.layer.borderColor = CustomColor.green.color.cgColor
        v.layer.cornerRadius = 14
        return v
    }()
  
        private lazy var questionLbl: UILabel = {
            let l = UILabel()
            l.font = Font.kohoSemibold16.chooseFont
            l.textColor = CustomColor.green.color
            l.textAlignment = .center
            l.text = "Etkinliğe katılmak istiyor musun?"
            return l
        }()
        
    private lazy var yesBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 14
        btn.layer.borderColor = CustomColor.green.color.cgColor
        btn.layer.borderWidth = 2
        let attributedTitle = NSAttributedString(
            string: "Evet",
            attributes: [
                .font: Font.kohoSemibold16.chooseFont, // İstediğiniz font'u ayarlayın
                .foregroundColor: CustomColor.green.color
            ]
        )
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.backgroundColor = CustomColor.lightGreen.color
        btn.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var noBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 14
        btn.layer.borderColor = CustomColor.green.color.cgColor
        btn.layer.borderWidth = 2
        // NSAttributedString oluştur
        let attributedTitle = NSAttributedString(
            string: "Hayır",
            attributes: [
                .font: Font.kohoSemibold16.chooseFont, // İstediğiniz font'u ayarlayın
                .foregroundColor: CustomColor.green.color
            ]
        )
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.backgroundColor = CustomColor.lightGreen.color
        btn.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    setupView()
    }
    //TODO: burada alınan participant verisine ekleme yapılacak
  @objc func yesTapped() {
      guard let userID = userID else { return }
      let databaseRef = Database.database().reference()
      let path = "zoom/activity1/participants"

      getFCMToken { token in
          print("Kullanıcının token'ı: \(token)")

          // Yeni değeri doğrudan ilgili path ve token üzerine ekleyin
          databaseRef.child(path).child(token!).setValue(true) { (error, _) in
              if let error = error {
                  print("Veri eklenirken hata oluştu: \(error.localizedDescription)")
              } else {
                  print("Veri başarıyla eklendi.")
                  self.dismiss(animated: true)
              }
          }
      }
  }

//  @objc func yesTapped() {
//      guard let userID = userID else { return }
//      let databaseRef = Database.database().reference()
//      let path = "zoom/activity2"
//
//      getFCMToken { token in
//          print("Kullanıcının token'ı: \(token)")
//
//          // İlgili path'teki veriyi al
//          databaseRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
//              if snapshot.exists() {
//                  if var activityData = snapshot.value as? [String: Any] {
//                      // İlgili path'teki participants array'ini al
//                      var participants: [String] = activityData["participants"] as? [String] ?? []
//
//                      // Yeni değeri participants array'ine ekle
//                    participants.append(token!)
//
//                      // participants array'ini güncelle
//                      activityData["participants"] = participants
//
//                      // Güncellenmiş veriyi kaydet
//                      databaseRef.child(path).setValue(activityData) { (error, _) in
//                          if let error = error {
//                              print("Veri güncellenirken hata oluştu: \(error.localizedDescription)")
//                          } else {
//                              print("Veri başarıyla güncellendi.")
//                              self.dismiss(animated: true)
//                          }
//                      }
//                  } else {
//                      print("Veri alınamadı veya uygun formatta değil.")
//                  }
//              } else {
//                  print("Path bulunamadı.")
//              }
//          }
//      }
//  }

    @objc func noTapped() {
     
        dismiss(animated: true)
    }
  func getFCMToken(completion: @escaping (String?) -> Void) {
      Messaging.messaging().token(completion: { token, error in
          if let error = error {
              print("FCM token alınamadı: \(error.localizedDescription)")
              completion("simülatorden veri geldi.")
          } else if let token = token {
              print("FCM token başarıyla alındı: \(token)")
              completion(token)
          }
      })
  }
    
        private func setupView() {
            view.backgroundColor = .clear
            view.addSubViews(view1)
            view1.addSubViews(yesBtn,questionLbl,noBtn)
            setupLayout()
        }
        private func setupLayout() {
            view1.snp.makeConstraints { make in
                make.height.equalTo(134)
                make.width.equalTo(350)
                make.centerX.centerY.equalToSuperview()
            }
            questionLbl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(25)
                make.leading.equalToSuperview().offset(50)
                make.trailing.equalToSuperview().offset(-50)
                make.height.equalTo(30)
            }
            yesBtn.snp.makeConstraints { make in
                make.width.equalTo(75)
                make.height.equalTo(42)
                make.leading.equalToSuperview().offset(56)
                make.bottom.equalToSuperview().offset(-12)
            }
            noBtn.snp.makeConstraints { make in
                make.width.equalTo(75)
                make.height.equalTo(42)
                make.trailing.equalToSuperview().offset(-56)
                make.bottom.equalToSuperview().offset(-12)
            }
        }

    }



