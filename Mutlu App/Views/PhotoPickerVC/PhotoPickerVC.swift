//
//  PhotoPickerVC.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
//import openssl_grpc
import Firebase
import FirebaseStorage

class PhotoPickerVC: UIViewController {
    
   
    
    let array = [ #imageLiteral(resourceName: "duckLaugh"), #imageLiteral(resourceName: "duckFly"), #imageLiteral(resourceName: "duckBallon"), #imageLiteral(resourceName: "duckBallon"), #imageLiteral(resourceName: "duckLaugh"), #imageLiteral(resourceName: "duckFly"), #imageLiteral(resourceName: "duckBallon"), #imageLiteral(resourceName: "duckBallon") ]
    var imageURLs = [URL]()
    var userType: UserType?
    var ageRange: AgeRange?
    
    private var selectedIndexPath: IndexPath?
    
    var choosenImage: URL? = nil
    
    var delegate: PhotoChanger?
    
    private lazy var collectionView: UICollectionView = {
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.scrollDirection = .vertical
         flowLayout.minimumLineSpacing = 65
         flowLayout.minimumInteritemSpacing = 65
         let cv = UICollectionView(frame: .zero,collectionViewLayout: flowLayout)
         cv.register(PhotoCell.self, forCellWithReuseIdentifier: "photo")
         cv.delegate = self
         cv.dataSource = self
         cv.isPagingEnabled = false
         cv.showsHorizontalScrollIndicator = false
         cv.contentInsetAdjustmentBehavior = .never
         cv.backgroundColor = .clear
        
         cv.layoutIfNeeded()
         return cv
     }()
    
    private lazy var chooseBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Seç", for: .normal)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        downloadImagesFromFirebaseStorage { (urls, error) in
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                } else if let urls = urls {
                    // Firebase Storage'dan alınan URL'leri imageURLs dizisine ata
                    self.imageURLs = urls
                    print(self.imageURLs.count)
                    // UICollectionView'ı güncelle
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
    }
    
    @objc func btnTapped() {
        delegate?.changePhoto(imageURL: choosenImage!)
        dismiss(animated: true, completion: nil)
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(collectionView,chooseBtn)
        setupLayout()
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalTo(chooseBtn.snp.top).offset(-20)
        }
        
        chooseBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
    }
    func downloadImagesFromFirebaseStorage(completion: @escaping ([URL]?, Error?) -> Void) {
        
        let storage = Storage.storage()
        
        if userType == .child {
           
        let storageRef = storage.reference().child("duck") // Klasör yolunu belirtin

        // Klasör içindeki tüm dosyaları listele
        storageRef.listAll { (result, error) in
            if let error = error {
                // Hata durumunda
                completion(nil, error)
                return
            }

            var imageUrls: [URL] = []

            // Her bir dosya için URL oluştur
            for item in result!.items {
                item.downloadURL { (url, error) in
                    if let url = url {
                        imageUrls.append(url)
                    } else if let error = error {
                        // URL oluştururken hata durumunda
                        completion(nil, error)
                        return
                    }

                    // Tüm dosyaların URL'leri alındığında completion bloğunu çağır
                    if imageUrls.count == result!.items.count {
                        completion(imageUrls, nil)
                    }
                }
            }
        }
        } else {
            let storageRef = storage.reference().child("avokado") // Klasör yolunu belirtin

            // Klasör içindeki tüm dosyaları listele
            storageRef.listAll { (result, error) in
                if let error = error {
                    // Hata durumunda
                    completion(nil, error)
                    return
                }

                var imageUrls: [URL] = []

                // Her bir dosya için URL oluştur
                for item in result!.items {
                    item.downloadURL { (url, error) in
                        if let url = url {
                            imageUrls.append(url)
                        } else if let error = error {
                            // URL oluştururken hata durumunda
                            completion(nil, error)
                            return
                        }

                        // Tüm dosyaların URL'leri alındığında completion bloğunu çağır
                        if imageUrls.count == result!.items.count {
                            completion(imageUrls, nil)
                        }
                    }
                }
            }
        }
    }
}

extension PhotoPickerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.frame.width - 1) / 3, height: 115)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        choosenImage = imageURLs[indexPath.row]
        collectionView.reloadData()
    }
}

extension PhotoPickerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}
        cell.layer.borderWidth = 0
              
              if indexPath == selectedIndexPath {
                  cell.layer.borderWidth = 2
                  cell.layer.borderColor = UIColor.yellow.cgColor
              }
        cell.configure(imageURL: imageURLs[indexPath.row])
        
        return cell
    }
    
    
}
