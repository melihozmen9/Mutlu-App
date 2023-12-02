//
//  LetterVC.swift
//  Mutlu App
//
//  Created by Kullanici on 27.08.2023.
//

import UIKit
import TinyConstraints
import FirebaseDatabase

class LetterVC: UIViewController {
    
    var penpalIDKey: String?
    var userType: String?
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "letter")
        return iv
    }()
    
//    private lazy var letterTV: UITextView = {
//        let tv = UITextView()
//        tv.backgroundColor = .blue
//        tv.isScrollEnabled = true
//        tv.isEditable = true
//        return tv
//    }()
    //FIXME: - letter' a tıknlanınca placeholder değişecek. bunun için textView'ın delegate özelliği kullan.
    private var letterTV: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.text = "Değerli Arkadaşım"
        textView.font = UIFont(name: "Kalam-Regular", size: 18)
        return textView
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemRed
        button.titleLabel?.font = UIFont(name: "Mansalva-Regular", size: 15)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Geri Dön", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPink, NSAttributedString.Key.font: UIFont(name: "Mansalva-Regular", size: 18)!]), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupView()
    }
    
    @objc private func backButtonTapped() {
     dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        print("butona baısldı")
        if let text = letterTV.text {
            let formatter = DateFormatter()
            let locale = Locale(identifier: "tr_TR")
            formatter.locale = locale
            formatter.dateFormat = "dd MMMM yyyy, EEEE"
            let dateString = formatter.string(from: Date())
            print(dateString)
            let lettersData: [String: Any] = [
                   "text": text,
                   "date": dateString,
                   "sender": userType,
                   "isFiltered" : false
               ]
            let dateData: [String:String] = [
                "lastDate": dateString
            ]
            
            let databaseRef = Database.database().reference()
            
             guard let penpalIDKey = penpalIDKey else {return }
            print(penpalIDKey)
            let newPenpalsRef = databaseRef.child("penpals").child(penpalIDKey)
            newPenpalsRef.updateChildValues(dateData)
            let newLetterRef = newPenpalsRef.child("letters").childByAutoId() // selectedPenpalsID, güncellenmek istenen penpals verisinin ID'si olmalı
            newLetterRef.setValue(lettersData) { (error, ref) in
                if let error = error {
                    print("Error adding letter data: \(error.localizedDescription)")
                } else {
                    print("Letter data added successfully.")
                }
            }
            
            
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupView() {
        view.addSubViews(imageview,letterTV,backButton,saveButton)
        setupLayout()
    }
    private func setupLayout() {
        imageview.edgesToSuperview()
        
        letterTV.edgesToSuperview(insets: .top(view.frame.height * 0.15) +
                                    .bottom(view.frame.height * 0.20) +
                                    .right(view.frame.width * 0.05) +
                                    .left(view.frame.width * 0.05), usingSafeArea: false)
        
        backButton.edgesToSuperview(excluding: [.bottom,.right], insets: .left(view.frame.size.width * 0.05) + .top(view.frame.size.height * 0.05))
        backButton.width(view.frame.size.width * 0.2)
        backButton.height(40)
        
        
        saveButton.centerX(to: letterTV)
        saveButton.height(view.frame.size.width * 0.07)
        saveButton.bottomToSuperview(offset: -view.frame.size.height * 0.07)
    }

}
