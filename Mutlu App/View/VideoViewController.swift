//
//  VideoViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit
import SnapKit

class VideoViewController: UIViewController {

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoCell")
        return tableView
    }()
    
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
    
    private var Video = [VideoModel]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       configure()
        
         Video = [
        VideoModel(name: "1 Kalem 1 Kağıt",
                   url: "https://www.youtube.com/watch?v=ODQ8eVLk_0w",
                   explanation: "İki kişiyle oynanabilen eğlenceli oyunlar",
                   image: UIImage(named: "kalemKagıt")!),
        VideoModel(name: "İpi Parmağa Geçirme Oyunu",
                   url: "https://www.youtube.com/watch?v=8y6wUIlsFMQ",
                   explanation: "İki kişiyle oynanan gittikçe zorlaşan ama bir o kadar eğlenceli bir oyun",
                   image: UIImage(named: "ipOyunu")!),
        VideoModel(name: "Evde Kağıttan İki Kişilik Oyun Yapımı",
                   url: "https://www.youtube.com/watch?v=DIZ9VLLyyWE",
                   explanation: "İki kişiyle oynanan zevkli bir oyun",
                   image: UIImage(named: "kagıtOyunu")!),
        VideoModel(name: "Bilmeceler",
                   url: "https://www.youtube.com/watch?v=HDgK7mFS_DM",
                   explanation: "Çocuk bilmeceleri",
                   image: UIImage(named: "bilmece")!),
        
        ]
    }
    
    func configure() {
        view.addSubview(tableView)
        title = "Videolar"
        navigationItem.leftBarButtonItem = backButton
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    

}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Video.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoTableViewCell
        cell?.nameLabel.text = Video[indexPath.row].name
        cell?.explanationLabel.text = Video[indexPath.row].explanation
        cell?.customImageView.image = Video[indexPath.row].image
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(URL(string: Video[indexPath.row].url)! as URL,options: [:], completionHandler: nil)
    }
    
    
}
