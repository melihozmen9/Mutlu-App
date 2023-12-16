//
//  LetterReadVC.swift
//  Mutlu App
//
//  Created by Kullanici on 3.12.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class LetterReadVC: UIViewController {
    
    let databaseRef = Database.database().reference()
    
    var penpalIDs: String?
    var letters: [[String : Any]]?
    var userType: UserType?
    var newPersonName: String?
    
    private lazy var collectionView: UICollectionView = {
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.scrollDirection = .vertical
         flowLayout.minimumLineSpacing = 20
         flowLayout.minimumInteritemSpacing = 20
         let cv = UICollectionView(frame: .zero,collectionViewLayout: flowLayout)
         cv.register(LetterReadCell.self, forCellWithReuseIdentifier: "readCell")
         cv.delegate = self
         cv.dataSource = self
         cv.isPagingEnabled = false
         cv.showsHorizontalScrollIndicator = false
         cv.contentInsetAdjustmentBehavior = .never
         cv.backgroundColor = .clear
        
         cv.layoutIfNeeded()
         return cv
     }()
    
    private lazy var newLetterBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Yeni Mektup Gönder", for: .normal)
        btn.addTarget(self, action: #selector(newBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
        
        guard let penpalIDs = penpalIDs else {return}
        
        getLetters(forPenpalID: penpalIDs) { (lettersArray) in
            if let lettersArray = lettersArray {
                print("Mektuplar: \(lettersArray)")
                self.letters = lettersArray
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("Mektuplar alınamadı veya hata oluştu.")
            }
        }
        
    }
    
    @objc private func newBtnTapped() {
        
        guard let penpalIDs = penpalIDs else {return}

        getDetails(forPenpalIDs: penpalIDs)
       
    }
    
    
    func getLetters(forPenpalID penpalID: String, completion: @escaping ([[String: Any]]?) -> Void) {
        let penpalRef = databaseRef.child("penpals").child(penpalID)
        let lettersRef = penpalRef.child("letters")
        
        lettersRef.queryOrdered(byChild: "isFiltered").queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let lettersData = snapshot.value as? [String: [String: Any]] {
                    let filteredLettersArray = lettersData.values.filter { ($0["isFiltered"] as? Bool) == true }
                    completion(filteredLettersArray)
                } else {
                    let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "Mektup verileri çekilemedi"])
                    print(error)
                    completion(nil)
                }
            } else {
                let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "PenpalID bulunamadı"])
                print(error)
                completion(nil)
            }
        }
    }

    func getDetails(forPenpalIDs penpalID: String) {
        let letterVC = LetterWriteVC()
        letterVC.penpalIDKey = penpalIDs
        letterVC.userType = userType
        // Her penpalID için sorgu oluşturun.
     
            let penpalRef = databaseRef.child("penpals").child(penpalID)
            
            penpalRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    
                    if let penpalData = snapshot.value as? [String: Any],
                       let childUserID = penpalData["childUserID"] as? String,
                       let volunteerUserID = penpalData["volunteerUserID"] as? String,
                       let date = penpalData["lastDate"] as? String {
                        
                        var userType: String
                        var userID: String
                        
                        if self.userType?.rawValue == "child" {
                            userType = "volunteers"
                            userID = volunteerUserID
                        } else {
                            userType = "children"
                            userID = childUserID
                        }
                        self.getUserDetails(userID: userID, database: userType) { username in
                            if let username = username {
                                print("abcde\(username)")
                                letterVC.toWhom = username
                                self.navigationController?.pushViewController(letterVC, animated: true)
                            }
                        }
                    }
                
            }
        }
       
    }
    
    private func setupView() {
        
        view.backgroundColor = CustomColor.attributedWhite.color
        view.addSubViews(collectionView,newLetterBtn)
        setupLayout()
    }
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(newLetterBtn.snp.top).offset(20)
        }
        newLetterBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
        }
        
    }

    func getUserDetails(userID: String, database: String, completion: @escaping (String?) -> Void) {
        let reference = databaseRef.child(database)
        
        // Veritabanındaki belirli bir kullanıcıyı sorgulayın ve penpalIDs alanını alın.
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // Veritabanından gelen verileri dizi olarak alın.
                if let userData = snapshot.childSnapshot(forPath: userID).value as? [String: Any],
                   let username = userData["name"] as? String {
                    // Veri doğru çekildi, şimdi veri yapısını kontrol edebiliriz.
                    completion(username)
                } else {
                    // Kullanıcı bilgisi eksikse veya çekilemediyse hata döndürün.
                    let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bilgisi eksik veya çekilemedi"])
                    completion(nil)
                }
            } else {
                // Kullanıcı bulunamadıysa hata döndürün.
                let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
                completion(nil)
            }
        }
    }

}

extension LetterReadVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.size.width , height: 584)
        return size
    }
}

extension LetterReadVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "readCell", for: indexPath) as? LetterReadCell else {return UICollectionViewCell()}
        guard let letters = letters else {return cell}
       
        let value = letters[indexPath.row]
        if letters[indexPath.row]["sender"] as! String == userType!.rawValue {
            cell.configure(data: value, isMine: true)
        } else {
            cell.configure(data: value, isMine: false)
        }
        
        return cell
    }
    
    
}
