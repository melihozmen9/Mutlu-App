//
//  GetStartedVC.swift
//  Mutlu App
//
//  Created by Kullanici on 25.11.2023.
//

import UIKit
import SnapKit

class GetStartedVC: UIViewController {
    
    let tupleArray:[(String,String,UIImage)] = [("sayfa 1  dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit.", #imageLiteral(resourceName: "duckLaugh") ),
                                           ("sayfa 2 dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit.", #imageLiteral(resourceName: "duckFly") ),
                                           ("sayfa 3 dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit.", #imageLiteral(resourceName: "duckPaper") )]
  
    var index = 0
    
    private lazy var collectionView: UICollectionView = {
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.scrollDirection = .horizontal
         flowLayout.minimumLineSpacing = 0
         flowLayout.minimumInteritemSpacing = 0
         let cv = UICollectionView(frame: .zero,collectionViewLayout: flowLayout)
         cv.register(GetStartedCell.self, forCellWithReuseIdentifier: "gsCell")
         cv.delegate = self
         cv.dataSource = self
         cv.isPagingEnabled = true
         cv.showsHorizontalScrollIndicator = false
         cv.contentInsetAdjustmentBehavior = .never
         cv.backgroundColor = .clear
        
         cv.layoutIfNeeded()
         return cv
     }()
    
    private lazy var pageControl: UIPageControl = {
          let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = CustomColor.anaSarı.color.withAlphaComponent(0.20)
        pageControl.currentPageIndicatorTintColor = CustomColor.anaSarı.color
        pageControl.numberOfPages = tupleArray.count
          pageControl.currentPage = index
          return pageControl
      }()
    
    private lazy var nextBtn: CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Devam Et", for: .normal)
        btn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return btn
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setGetStartedScreenShown()
    }
    
    @objc func nextTapped() {
        if index < 3 {
        
            switch index {
            case 0:
                index += 1
                let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
           
               
            case 1:
                index += 1
                let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
               
                nextBtn.setTitle("Giriş Yap", for: .normal)
            case 2:
                self.navigationController?.pushViewController(LoginVC(), animated: true)
            default:
                break
            }
        }
    }
    
    func setGetStartedScreenShown() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "hasShownGetStarted")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(collectionView,pageControl,nextBtn)
        setupLayout()
    }
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-60)
            make.leading.equalToSuperview().offset(162)
            make.trailing.equalToSuperview().offset(-162)
            make.height.equalTo(10)
        }
        nextBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-86)
        }
    }

}


extension GetStartedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.size.width, height: 600)
        return size
    }
}

extension GetStartedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tupleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gsCell", for: indexPath) as? GetStartedCell else {return UICollectionViewCell()}
        cell.configure(item: tupleArray[indexPath.row])
        
        return cell
    }
    
    
}
