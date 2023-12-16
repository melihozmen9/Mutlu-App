import UIKit
import PDFKit
import FirebaseStorage
import SnapKit

class ChildRightsVC: UIViewController {

    var pdfView = PDFView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Firebase Storage'dan PDF dosyasının URL'sini al ve görüntüle
        downloadPDFURLFromFirebase()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(pdfView)
        setupLayout()
    }

    private func setupLayout() {
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func downloadPDFURLFromFirebase() {
        // Firebase Storage referansını al
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // PDF dosyasının bulunduğu konumu belirtin (Firebase Storage'da)
        let pdfRef = storageRef.child("childRights/childRights.pdf")

        // PDF dosyasının indirme URL'sini al
        pdfRef.downloadURL { url, error in
            if let error = error {
                print("PDF URL alınamadı: \(error.localizedDescription)")
            } else if let pdfURL = url {
                // PDF URL alındı, şimdi PDF dosyasını görüntüle
                self.displayPDF(from: pdfURL)
            }
        }
    }

    private func displayPDF(from url: URL) {
        if let document = PDFDocument(url: url) {
            DispatchQueue.main.async {
                self.pdfView.document = document
                self.pdfView.autoScales = true
            }
        } else {
            print("PDF belgesi oluşturulamadı.")
        }
    }
}
