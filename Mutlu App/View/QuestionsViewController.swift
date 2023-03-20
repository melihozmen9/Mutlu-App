//
//  denemtableViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//


import UIKit
import SnapKit

class QuestionsViewController: UIViewController{
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(AnswerTableViewCell.self, forCellReuseIdentifier: "Answer")
        tableview.register(QuestionTableViewCell.self, forCellReuseIdentifier: "Question")
        return tableview
    }()
    
    private var sections = [section]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataAndTableView()
        configure()
    }
    func configure() {
        view.addSubview(tableView)
        view.backgroundColor = .red
        title = "Sorular"
        navigationItem.leftBarButtonItem = backButton
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalToSuperview().offset(-view.frame.size.height * 0.2)
            
        }
    }
    func dataAndTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        
        sections =  [
            section(title: "Port Nedir?", options: ["Port göğüs bölgesine yerleştirilen, yumuşak plastikten yapılan incecik bir borudur. Port takılmasının amacı, sana iğne yapmadan ve canını acıtmadan ilaç verebilmektir. Bu yapılırken seni uyuturlar ve bu yüzden canın hiç yanmayacak. Alet sayesinde acısız kan alınabilir ve verilebilir. Port haftalarca yada aylarca vücudunda kalabilir ve dışarıdan kimse bunu görmez/anlamaz. Tedavin bittiğinde, canın yanmadan sen uykudayken çıkarılır."]),
            section(title: "Ameliyat Nedir?", options: ["Büyümemiz için hücrelerimiz her gün gelişir ve gerektiğinde çoğalarak yeni hücreler oluşturur. Ama bazen normalden daha hızlı büyüyebilir ve çoğalabilirler. Bu durumda fazla olan hücreler bedenimizin doğal çalışmalarını engelleyebilir ve bizi hasta edebilir. Bu yüzden bu hücrelerin alınması gerekir ve bu işleme ameliyat denilir. Ameliyat yapılmadan önce, doktor seni gevşetecek ve sonra uyumanı sağlayacak ilaçlar verir. Böylece sen ameliyat sırasında derin bir uykuda olursun ve yapılan işlemleri hissetmezsin. Canın hiç acımaz. Uyandığında yatağında yatıyor olacaksın. Bu işlem hem çocuklara hem büyüklere yapılabilir."]),
            section(title: "Radyoterapi Nedir?", options: ["Radyoterapi yani ışın tedavisi, dışarıdan gözle görülmeyen ışınlar vererek normalden daha hızlı büyüyen hücrelerini yok etmek veya küçültmek için kullanılan bir tedavi yöntemidir. Işınları göremez ve hissedemezsin. Tek yapman gereken, işlem sırasında elinden geldiğinde hareketsiz durmaktır. Bu tedavi hiç canını acıtmaz."]),
            section(title: "Tomografi Nedir?", options: ["Tomografi, diğer adıyla PET ve BT, doktorların bazı hastalıkları bulmak için vücudumuza detaylıca baktığı bir yöntemdir. Vücudun bir resmini çıkartır ve doktorun senin tedavini planlamasına yardımcı olur. Alet kocaman bir simit gibi görünür. Sen özel bir yatağa yatarsın ve bu yatak bu simidin içinden geçer. İşlem sırasında hiçbir şey yapmana gerek yok sadece hareketsiz kalman yeterli. Bu işlem olurken canın hiç yanmayacak."]),
            section(title: "Kemik İliği Örnek Alımı", options: ["Doktorların senin kemiğinin içinde bulunan ilikten bir parça örnek almasıdır. Bunu kemik iliğinin yapısını anlayabilmek için alır. Böylece doktor, senin kanın ile ilgili bir hastalığın olup olmadığını anlar. Genelde kalça kemiği gibi büyük kemiklerden alınır. Bu işlem olurken doktorun senin gevşemen için verdiği ilaçlar ile uykun gelebilir. Sonrasında senden yüzüstü ya da yana doğru yatmanı ister. Önce cildini temizler, sonra da küçük bir iğne ile verdiği ilaçla o bölgeyi uyuşturur. Böylece örnek alınırken senin canın hiç yanmaz."]),
            section(title: "Kemoterapi Nedir?", options: ["Kemoterapi, normalden daha hızlı büyüyen hücrelerin tedavisinde kullanılan çok güçlü bir ilaçtır. Kısaca kemo da denir. Bazen serumla damarından, bazen de hap olarak ağızdan verilebilir. İkisinin de sonunda ilaç kanına karışır ve bu şekilde vücuduna dağılır. Çok güçlü bir ilaç demiştim ya, bu yüzden bazen hızlı büyüyen hücreleri yok ederken bazı normal hücreleri de yok edebilir. O zaman yan/bazı etkiler oluşur. Miden bulanabilir, saçların dökülebilir veya kendini çok yorgun hissedebilirsin. Ama bunlar tedavin bittiğinde geçecektir."])
        ]
    }
}


extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Question",for: indexPath) as? QuestionTableViewCell
            cell!.questionLabel.text = sections[indexPath.section].title
            return cell!
        } else {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "Answer",for: indexPath) as? AnswerTableViewCell
            answerCell?.answerLabel.text = sections[indexPath.section].options[indexPath.row - 1]
            answerCell!.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
            return answerCell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
