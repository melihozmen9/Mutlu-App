

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class QuestionsViewController: UIViewController{
    
    
    private let backgroundImage = UIImage(named: "background3")
    private var backgroundImageView = UIImageView()
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(AnswerTableViewCell.self, forCellReuseIdentifier: "Answer")
        tableview.register(QuestionTableViewCell.self, forCellReuseIdentifier: "Question")
        return tableview
    }()
    
    private let questionTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPurple,
            .font: UIFont.italicSystemFont(ofSize: 15)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Soru sorabilirsin :)", attributes: attributes)
        textField.backgroundColor = .white
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return button
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
    
    @objc private func sendTapped() {
        sendQuestion()
    }
    
    @objc func menuButtonTapped() {
        let menuViewController = UINavigationController(rootViewController: MenuViewController())
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.modalTransitionStyle = .crossDissolve
            present(menuViewController, animated: true, completion: nil)
    }
    
    let database = Database.database().reference()
    private var sections = [QuestionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataAndTableView()
        configure()
        getQuestions()
        
    }
    
    func getQuestions() {

        database.child("questions").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
<<<<<<< HEAD
            // Verileri [QuestionModel] arrayine dönüştürür
=======
>>>>>>> feature
            for (_, value) in data {
                let title = value["title"] as? String ?? ""
                let options = value["options"] as? [String] ?? []
                let isOpened = value["isOpened"] as? Bool ?? false
                let images = value["image"] as? [String] ?? []
                
                let question = QuestionModel(title: title, options: options, isOpened: isOpened, image: images)
                self.sections.append(question)
            }
            self.tableView.reloadData()
        })
    }
    
    func sendQuestion() {
        if let questionText = questionTextField.text {
            let questionRef = database.child("sorular").childByAutoId()
            questionRef.setValue(questionText)
        }
        questionTextField.text = ""
        questionTextField.placeholder = "Sorun gönderildi. Başka sorun var mı?"
    }
    
    func design() {
        view.backgroundColor = UIColor(red: 0.25, green: 0.75, blue: 0.79, alpha: 1.00)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
        title = "Sorular"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "menubar.rectangle"), style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    func configure() {
        design()
        view.addSubview(tableView)
        view.addSubview(questionTextField)
        view.addSubview(sendButton)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalToSuperview().offset(-view.frame.size.height * 0.1)
        }
        questionTextField.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(sendButton.snp.left).offset(-10)
            make.bottom.equalTo(view).offset(-10)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    func dataAndTableView() {
        tableView.rowHeight = view.frame.size.height * 0.13
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.25, green: 0.75, blue: 0.79, alpha: 1.00)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
   
}


extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.isOpened ? 2 : 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Question",for: indexPath) as? QuestionTableViewCell
            cell?.questionLabel.text = sections[indexPath.section].title
            cell?.configureUrl(with: (sections[indexPath.section].image?[0])! )
            return cell!
        } else {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "Answer",for: indexPath) as? AnswerTableViewCell
            answerCell?.answerLabel1.text = String(sections[indexPath.section].options?[0] ?? "")
            answerCell?.answerLabel2.text = String?(sections[indexPath.section].options?[1] ?? "")
            answerCell?.configureUrl(with: (sections[indexPath.section].image?[0])!, with: (sections[indexPath.section].image?[1])!)
            answerCell!.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
            return answerCell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return view.frame.size.height * 0.15
        } else {
            return view.frame.size.height * 0.45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
