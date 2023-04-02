//
//  DiaryViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit
import SnapKit
import CoreData

class DiaryViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    private let topView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 1.00, green: 0.87, blue: 0.87, alpha: 1.00)
        
        return view
    }()
    

    @objc func topViewTapped() {
        let diaryPageViewController = UINavigationController(rootViewController: DiaryPageViewController())
        diaryPageViewController.modalPresentationStyle = .fullScreen
        diaryPageViewController.modalTransitionStyle = .crossDissolve
         present(diaryPageViewController, animated: true, completion: nil)
    }
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeni Bir Sayfa"
        label.font = UIFont(name: "Baloo2-SemiBold", size: 25)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imageview: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainLabelImage"))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var diaryArray = [Diary]()
    
//    var savedTexts: [DiaryModel] = [
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "27 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "26 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "25 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "24 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "23 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "22 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "21 Nisan, Çarşamba"),
//        DiaryModel(diaryText: "SEvgili Gnlük bu bir deneme textidir. kişisel algılama.", date: "20 Nisan, Çarşamba")
//    ]
    
    private func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backButtonTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink, NSAttributedString.Key.font: UIFont(name: "Mansalva-Regular", size: 18)!], for: .normal)
        return button
    }
    
    lazy var backButton: UIBarButtonItem = {
        return createBackButton()
    }()
    
    @objc private func backButtonTapped() {
     dismiss(animated: true, completion: nil)
    }
    
    var imageArray: [UIImage] = [
        UIImage(named: "sun")!,
        UIImage(named: "flower1")!,
        UIImage(named: "flower2")!,
        UIImage(named: "heart")!,
        UIImage(named: "whale")!,
        UIImage(named: "lion")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        configure()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loadDiary()
         tableView.reloadData()
    }
    
    func loadDiary(){
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        do {
            diaryArray = try context!.fetch(request)
        } catch {
            print("error \(error)")
        }
    }
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryCell")
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIView(frame: CGRect.zero)
        tableView.isOpaque = false
    }
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(tapGesture)
        title = "Günlük"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
        
        
        view.addSubview(topView)
        view.addSubview(tableView)
        topView.addSubview(mainLabel)
        topView.addSubview(imageview)
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).offset(view.frame.size.height * 0.01)
            make.centerY.equalTo(topView.snp.centerY)
            make.width.equalTo(topView.snp.width).multipliedBy(0.7)
        }
        
        imageview.snp.makeConstraints { make in
            make.right.equalTo(topView)
            make.centerY.equalTo(topView.snp.centerY)
            make.width.height.equalTo(topView.snp.height).multipliedBy(0.7)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.height * 0.03)
            make.left.equalTo(view).offset(view.frame.size.width * 0.20)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.20)
            make.height.equalTo(view.frame.size.height * 0.10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(view.frame.size.height * 0.03)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.80)
            make.bottom.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as? DiaryTableViewCell
        cell?.dayLabel.text = diaryArray[indexPath.row].tarih
        cell?.dayImage.image = imageArray.shuffled()[0]
        cell?.backgroundColor = UIColor.clear
        cell?.isOpaque = false
        cell?.backgroundView = UIView(frame: CGRect.zero)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let diaryReadViewController = DiaryReadViewController()
        diaryReadViewController.diaryLabel.text = diaryArray[indexPath.row].metin

        navigationController?.pushViewController(diaryReadViewController, animated: true)
    }
    
  
    
    
}
