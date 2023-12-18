//
//  QuestionVC.swift
//  Mutlu App
//
//  Created by Kullanici on 12.11.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class VideosVC: UIViewController {
    
    var childPickerTitle = [VideoTypes.eglence,VideoTypes.elisi,VideoTypes.moral]
    var parentPickerTitle = [VideoTypes.gelisim,VideoTypes.moral,VideoTypes.oyun]
    
    var videoArray = [VideosModel]()
    
    var userType: UserType?
    var ageRange: AgeRange?
    var userID: String?
    
    var videoType: String = "" {
           didSet {
               // Video tipi değiştiğinde yapılacak işlemleri burada tanımlayabilirsiniz.
               // Örneğin, yeni bir veri çekme işlemi başlatılabilir.
               fetchVideos()
           }
       }
    
    //var videoType: String =  "oyun"
    
//"https://mutlu-app-default-rtdb.europe-west1.firebasedatabase.app/NewBase/refakatci/videolar/oyun"
    
    private lazy var dropdownView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColor.anaSarı.color.cgColor
        view.backgroundColor = CustomColor.anaSarı.color.withAlphaComponent(0.15)
        view.layer.cornerRadius = 28

        let titles = userType == .child ? childPickerTitle : parentPickerTitle
        let selectedTitle = titles.first?.choosenType ?? ""
       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 100
        // Metin
        let attributedString = NSAttributedString(string: selectedTitle, attributes: [
            NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
            NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
        ])
        let label = UILabel()
        label.attributedText = attributedString

        stackView.addArrangedSubview(label)

        // Aşağı yönlü ok görseli
        let arrowImage = UIImage(systemName: "chevron.down")
        let arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.tintColor = CustomColor.anaSarı.color

        stackView.addArrangedSubview(arrowImageView)


        view.addSubview(stackView)
        

        // StackView'a constraint'leri ayarla
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }

        // UIView'a dokunma tanımla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownViewTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }()
    
    private lazy var tableView : UITableView = {
           let tableView = UITableView()
        tableView.backgroundColor = .clear
           tableView.separatorStyle = .none
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
           tableView.backgroundColor = .clear
           return tableView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchVideos()
    }
    
    
    func fetchVideos() {
        videoArray.removeAll()
        let videoTypePath: String
        if videoType != "" {
            videoTypePath = videoType
        } else {
            if userType == .child {
                videoTypePath = setType(value: childPickerTitle[0].choosenType)
            } else {
                videoTypePath = setType(value: parentPickerTitle[0].choosenType)
            }
            
        }
        switch userType {
        case .child:
            //age sorgusu gelecek
            guard let ageRange = ageRange else { return }

            let ref = Database.database().reference().child("NewBase/cocuk/\(ageRange.rawValue)/videolar/\(videoTypePath)")
            fetchData(ref: ref)
        case .parent:
            let ref = Database.database().reference().child("NewBase/\(userType!.category)/videolar/\(videoTypePath)")
            fetchData(ref: ref)
        case .volunteer:
            let ref = Database.database().reference().child("NewBase/\(userType!.category)/videolar")
            fetchData(ref: ref)
        case .none:
            break
        }
      
        }
    
    func fetchData(ref: DatabaseQuery) {
        print(ref)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }

            if let data = snapshot.value as? [String: Any] {
                print(data)
                for (_, value) in data {
                    if let videoData = value as? [String: Any],
                        let link = videoData["link"] as? String,
                        let image = videoData["image"] as? String,
                        let detail = videoData["detail"] as? String,
                        let title = videoData["title"] as? String {

                        let video = VideosModel(title: title, detail: detail, image: image, link: link)
                        self.videoArray.append(video)
                    }
                }
                print(self.videoArray[0].detail)
                self.tableView.reloadData()
            } else {
                print("veri alınamadı")
            }
        }
    }


    
    
    
    private func setupView() {
        view.backgroundColor = .white
      if userType == .volunteer {
        view.addSubViews(tableView)
            
      } else {
        view.addSubViews(dropdownView)
        view.addSubViews(tableView)
      }
       
        setupLayout()
    }
    private func setupLayout() {
      if userType == .volunteer {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.leading.trailing.equalToSuperview()
        }
      } else {
        dropdownView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(50)
        }
          tableView.snp.makeConstraints { make in
              make.top.equalTo(dropdownView.snp.bottom).offset(20)
              make.bottom.leading.trailing.equalToSuperview()
          }
      }
   
    }
    
    @objc func dropdownViewTapped() {
        showDropdownMenu()
    }
    func showDropdownMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let titles = userType == .child ? childPickerTitle : parentPickerTitle

        for title in titles {
            let action = UIAlertAction(title: title.choosenType, style: .default) { [weak self] _ in
                self?.handleDropdownSelection(title.rawValue)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let presentationController = alertController.popoverPresentationController {
            presentationController.sourceView = dropdownView
            presentationController.sourceRect = dropdownView.bounds
        }

        present(alertController, animated: true, completion: nil)
    }

    func handleDropdownSelection(_ selectedTitle: String) {
        guard let videoType = VideoTypes(rawValue: selectedTitle.lowercased()) else {
            // Belirtilen title'a karşılık gelen bir VideoTypes değeri bulunamazsa, fonksiyonu bitir.
            return
        }
        
        updateDropdownViewTitle(videoType.choosenType)
    }

    func updateDropdownViewTitle(_ selectedTitle: String) {
          // Dropdown menü seçildiğinde video tipini güncelle
        videoType = setType(value: selectedTitle)
         
          
          if let stackView = dropdownView.subviews.first as? UIStackView,
              let label = stackView.arrangedSubviews.first as? UILabel {

              let attributedString = NSAttributedString(string: selectedTitle, attributes: [
                  NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
                  NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
              ])
              label.attributedText = attributedString
          }
      }

    private func setType(value: String) -> String {
        let videoType: String
        switch value {
        case VideoTypes.moral.choosenType:
            videoType = "moral"
        case VideoTypes.gelisim.choosenType:
            videoType = "gelisim"
        case VideoTypes.oyun.choosenType:
            videoType = "oyun"
        case VideoTypes.elisi.choosenType:
            videoType = "elisi"
        case VideoTypes.eglence.choosenType:
            videoType = "eglence"
        default:
            videoType = ""
        }
        return videoType
    }


}

extension VideosVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(URL(string: videoArray[indexPath.row].link)! as URL,options: [:], completionHandler: nil)
    }
   
}

extension VideosVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        cell.configureVideo(item: videoArray[indexPath.row])
//        cell.rightView.isHidden = false
        return cell
    }
}

enum VideoTypes: String {
    case moral
    case gelisim
    case oyun
    case elisi
    case eglence
    
    var choosenType: String {
        switch self {
        case .moral:
            return "Moral Veren Videolar"
        case .gelisim:
            return "Gelişim Videoları"
        case .oyun:
            return "Oyun Videolar"
        case .elisi:
            return "Elişi Videoları"
        case .eglence:
            return "Eğlenceli Videolar"
        }
    }
}

