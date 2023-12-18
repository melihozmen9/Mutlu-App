//
//  LettersMainVC.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit
import Firebase

class LettersMainVC: UIViewController {
    
    var userType: UserType?
    var userID: String?
    let databaseRef = Database.database().reference()
    var penpalIDs: [String]?
    var letterDetails = [[String]]()
    var newPersonName: String?
    var penpalIDKey: String? {
        didSet {
            if let penpalIDKey = penpalIDKey {
                let letterVC = LetterWriteVC()
                letterVC.penpalIDKey = penpalIDKey
                letterVC.userType = userType
                letterVC.toWhom = newPersonName
                self.navigationController?.pushViewController(letterVC, animated: true)
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        let cv = UICollectionView(frame: .zero,collectionViewLayout: flowLayout)
        cv.register(LettersCell.self, forCellWithReuseIdentifier: "letter")
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .clear
        
        cv.layoutIfNeeded()
        return cv
    }()
  
  private lazy var emptyLetterView: EmptyLetterView = {
         let view = EmptyLetterView()
         return view
     }()
    
    private lazy var openLetterIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "openLetter")
        return iv
    }()
    
    private lazy var newPenpalBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Yeni Mektup Arkadaşı", for: .normal)
        btn.addTarget(self, action: #selector(newPenpalTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchPenpal()

    }
    @objc private func addButtonTapped() {
        present(LetterHelperVC(), animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = CustomColor.attributedWhite.color
        view.addSubViews(collectionView,openLetterIv,newPenpalBtn)
        setupNavigationBar()
        setupLayout()
    }
    private func setupNavigationBar() {
        // Sağa buton ekleyerek UIButton ve UIImageView oluşturun
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "info1x"), for: .normal)
       
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        // UIBarButtonItem oluşturun ve UIButton'ı içine yerleştirin
        let rightBarButton = UIBarButtonItem(customView: addButton)
        
        // Navigation Item'ınızı alın ve sağa butonu ekleyin
        navigationItem.rightBarButtonItem = rightBarButton
    }
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(openLetterIv.snp.top).offset(-20)
        }
        openLetterIv.snp.makeConstraints { make in
            make.height.equalTo(146)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(newPenpalBtn.snp.top).offset(-20)
        }
        newPenpalBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-82)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
    }
  
  func showEmptyLetterView() {
          // Eğer penpalIDs boşsa, boş ekran görünümünü ekranın ortasına bas
    collectionView.isHidden = true
          view.addSubview(emptyLetterView)
          emptyLetterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(openLetterIv.snp.top).offset(-20)
          }
      }
    
    
  func fetchPenpal() {
      guard let userType = userType, let userID = userID else {
          return
      }

      if userType.rawValue == "child" {
          self.getPenpalIDs(userID: userID, database: "children") { (penpalIDs, error) in
              if let error = error {
                  print("Veri çekme hatası: \(error.localizedDescription)")
                self.showEmptyLetterView()
              } else if let penpalIDs = penpalIDs {
                  if penpalIDs.isEmpty {
                      // Eğer penpalIDs boşsa, boş ekranı göster
                      self.showEmptyLetterView()
                  } else {
                      print("Penpal IDs: \(penpalIDs)")
                      // PenpalIDs boş değilse, detayları çek
                      self.getDetails(forPenpalIDs: penpalIDs)
                  }
              }
          }
      } else {
          self.getPenpalIDs(userID: userID, database: "volunteers") { (penpalIDs, error) in
              if let error = error {
                  print("Veri çekme hatası: \(error.localizedDescription)")
                self.showEmptyLetterView()
              } else if let penpalIDs = penpalIDs {
                  if penpalIDs.isEmpty {
                      // Eğer penpalIDs boşsa, boş ekranı göster
                      self.showEmptyLetterView()
                  } else {
                      print("Penpal IDs: \(penpalIDs)")
                      // PenpalIDs boş değilse, detayları çek
                      self.getDetails(forPenpalIDs: penpalIDs)
                  }
              }
          }
      }
  }

 
    func getPenpalIDs(userID: String, database: String, completion: @escaping ([String]?, Error?) -> Void) {
        let reference = databaseRef.child(database).child(userID)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else {
                // Kullanıcı bulunamadıysa hata döndürün.
                let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
                completion(nil, error)
                return
            }
            
            if let penpalIDsValue = snapshot.childSnapshot(forPath: "penpalIDs").value as? [String] {
                // Veri doğru çekildi, şimdi veri yapısını kontrol edebiliriz.
                self.penpalIDs = penpalIDsValue
                print(penpalIDsValue)
                self.getDetails(forPenpalIDs: self.penpalIDs!)
                completion(penpalIDsValue, nil)
            } else {
                // PenpalIDs bilgisi eksikse veya çekilemediyse hata döndürün.
                let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "PenpalIDs eksik veya çekilemedi"])
                completion(nil, error)
            }
        }
    }
    
    func getDetails(forPenpalIDs penpalIDs: [String]) {
        // Her penpalID için sorgu oluşturun.
        for penpalID in penpalIDs {
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
                                let item: [String] = [username, date, penpalID]
                                self.letterDetails.append(item)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
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

    
    //MARK: - Yeni arkadaş edinme
    @objc func newPenpalTapped() {
        
        let databaseRef = Database.database().reference()
        
        guard let userID = userID else { return}
      
        
        if userType?.rawValue == "child" {
            self.updateCountForCollection("children", userID: userID)
            databaseRef.child("volunteers").observeSingleEvent(of: .value) { (snapshot) in
                guard snapshot.exists(), let volunteersData = snapshot.value as? [String: [String: Any]] else { return }
                let totalDataCount = volunteersData.count
                let randomIndex = Int.random(in: 0..<totalDataCount)
                
                databaseRef.child("volunteers").queryOrderedByKey().queryLimited(toFirst: UInt(randomIndex + 1)).observeSingleEvent(of: .value) { (randomSnapshot) in
                    if randomSnapshot.exists(), let randomData = randomSnapshot.children.allObjects.last as? DataSnapshot {
                        
                        if let newPersonName = randomData.childSnapshot(forPath: "name").value as? String {
                                  print("Belirtilen indeksteki veri: \(randomData.key)")
                                  let volunteerID = randomData.key
                                  print("New Person Name: \(newPersonName)")
                            self.newPersonName = newPersonName
                            self.updateCountForCollection("volunteers", userID: volunteerID)
                          
                            let penpalsData: [String: Any] = [
                                "childUserID": userID,
                                "volunteerUserID": volunteerID,
                                "lastDate": "",
                                "childDeviceID": "empty",
                                "volunteerDeviceID": "empty"
                            ]
                            let newPenpalsRef = databaseRef.child("penpals").childByAutoId()
                            newPenpalsRef.setValue(penpalsData) { (error, ref) in
                                if let error = error {
                                    print("Error adding penpals data: \(error.localizedDescription)")
                                } else {
                                    if let newPenpalsID = newPenpalsRef.key {
                                        print("Penpals data added successfully with ID: \(newPenpalsID)")
                                        self.addPenpalIDToUserArray(collection: "children", userID: userID, penpalIDKey: newPenpalsID)
                                        self.addPenpalIDToUserArray(collection: "volunteers", userID: volunteerID , penpalIDKey: newPenpalsID)
                                        self.penpalIDKey = newPenpalsID
                                    }
                                }
                            }
                                  // Diğer işlemleri buraya ekleyebilirsiniz.
                              } else {
                                  print("Name not found in the random data.")
                              }
                      
                     
                    } else {
                        print("Belirtilen indeksteki veri çekilemedi.")
                    }
                }
        
            }
            
            
            
        } else if userType?.rawValue == "volunteer" {
            self.updateCountForCollection("volunteers", userID: userID)
            databaseRef.child("children").observeSingleEvent(of: .value) { (snapshot) in
                guard snapshot.exists(), let volunteersData = snapshot.value as? [String: [String: Any]] else { return }
                let totalDataCount = volunteersData.count
                let randomIndex = Int.random(in: 0..<totalDataCount)
                
                databaseRef.child("children").queryOrderedByKey().queryLimited(toFirst: UInt(randomIndex + 1)).observeSingleEvent(of: .value) { (randomSnapshot) in
                    if randomSnapshot.exists(), let randomData = randomSnapshot.children.allObjects.last as? DataSnapshot {
                        
                        print("Belirtilen indeksteki veri: \(randomData.key)")
                        let childID = randomData.key
                        self.updateCountForCollection("children", userID: childID)
                        let penpalsData: [String: Any] = [
                            "childUserID": childID,
                            "volunteerUserID": userID,
                            "lastDate": ""
                        ]
                        let newPenpalsRef = databaseRef.child("penpals").childByAutoId()
                        newPenpalsRef.setValue(penpalsData) { (error, ref) in
                            if let error = error {
                                print("Error adding penpals data: \(error.localizedDescription)")
                            } else {
                                if let newPenpalsID = newPenpalsRef.key {
                                    print("Penpals data added successfully with ID: \(newPenpalsID)")
                                    self.addPenpalIDToUserArray(collection: "children", userID: childID, penpalIDKey: newPenpalsID)
                                    self.addPenpalIDToUserArray(collection: "volunteers", userID: userID , penpalIDKey: newPenpalsID)
                                    self.penpalIDKey = newPenpalsID
                                }
                            }
                        }
                    } else {
                        print("Belirtilen indeksteki veri çekilemedi.")
                    }
                }
            }
        } else {
            print("Invalid user type.")
            
        }
    }
    
//    func addPenpalIDToUserArray(collection: String, userID: String, penpalIDKey: String) {
//        let databaseRef = Database.database().reference()
//
//        // Belirli bir koleksiyon içerisindeki veriyi bulma
//        databaseRef.child(collection).queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
//            if var dataToUpdate = snapshot.value as? [String: [String: Any]] {
//                // İlgili user verisini bulma
//                if let dataID = dataToUpdate.keys.first, var userData = dataToUpdate[dataID] {
//                    // PenpalID'yi eklemek için bir array oluşturun
//                    var penpalIDs: [String] = []
//
//                    // Eğer user zaten bir penpalID array'ine sahipse onu alın
//                    if let existingPenpalIDs = userData["penpalIDs"] as? [String] {
//                        penpalIDs = existingPenpalIDs
//                    }
//
//                    // PenpalID'yi array'e ekle
//                    penpalIDs.append(penpalIDKey)
//                    userData["penpalIDs"] = penpalIDs
//
//                    // Güncellenmiş veriyi kaydetme
//                    databaseRef.child(collection).child(dataID).setValue(userData) { (error, ref) in
//                        if let error = error {
//                            print("Error adding penpalID: \(error.localizedDescription)")
//                        } else {
//                            print("PenpalID added successfully.")
//                        }
//                    }
//                }
//            }
//        }
//    }
    func addPenpalIDToUserArray(collection: String, userID: String, penpalIDKey: String) {
        let databaseRef = Database.database().reference()
        
        // Belirli bir koleksiyon içerisindeki veriyi bulma
        databaseRef.child(collection).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let userData = snapshot.childSnapshot(forPath: userID).value as? [String: Any] {
                    // Kullanıcı verisi bulundu, penpalIDs array'ini güncelle
                    var penpalIDs: [String] = []
                    
                    // Eğer kullanıcı zaten bir penpalIDs array'ine sahipse onu al
                    if let existingPenpalIDs = userData["penpalIDs"] as? [String] {
                        penpalIDs = existingPenpalIDs
                    }
                    
                    // PenpalID'yi array'e ekle
                    penpalIDs.append(penpalIDKey)
                    
                    // Güncellenmiş veriyi kaydetme
                    databaseRef.child(collection).child(userID).child("penpalIDs").setValue(penpalIDs) { (error, ref) in
                        if let error = error {
                            print("PenpalID eklenirken hata oluştu: \(error.localizedDescription)")
                        } else {
                            print("PenpalID başarıyla eklendi. ilgili collection'a eklendi.")
                        }
                    }
                } else {
                    // Kullanıcı bilgisi eksikse veya çekilemediyse hata döndürün.
                    print("Kullanıcı verisi bulunamadı veya çekilemedi.")
                }
            } else {
                // Kullanıcı bulunamadıysa hata döndürün.
                print("Kullanıcı bulunamadı.")
            }
        }
    }



    
    func updateCountForCollection(_ collection: String, userID: String) {
        let databaseRef = Database.database().reference()
        
        // Belirli bir koleksiyon içerisindeki veriyi bulma
        databaseRef.child(collection).queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: [String: Any]],
               let dataID = data.keys.first,
               var dataToUpdate = data[dataID] {
                
                // Count değerini artırma
                if let currentCount = dataToUpdate["count"] as? Int {
                    dataToUpdate["count"] = currentCount + 1
                    
                    // Güncellenmiş veriyi kaydetme
                    databaseRef.child(collection).child(dataID).setValue(dataToUpdate) { (error, ref) in
                        if let error = error {
                            print("Error updating count: \(error.localizedDescription)")
                        } else {
                            print("Count updated successfully.")
                        }
                    }
                }
            }
        }
    }
    
    
}

extension LettersMainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 165, height: 127)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let readLettersVC = LetterReadVC()

        readLettersVC.navigationItem.title = letterDetails[indexPath.row][0]
        readLettersVC.penpalIDs = letterDetails[indexPath.section][2]
        readLettersVC.userType = userType
        navigationController?.pushViewController(readLettersVC, animated: true)
    }
}

extension LettersMainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "letter", for: indexPath) as? LettersCell else {return UICollectionViewCell()}
     print(letterDetails[indexPath.row][0])
        cell.configure(indexpath: indexPath.row , name: letterDetails[indexPath.row][0])
        
        return cell
    }
    
    
}
