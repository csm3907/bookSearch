//
//  DetailViewController.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import UIKit
import PDFKit

class DetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view: UIScrollView = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.isOpaque = true
        return imgView
    }()
    
    lazy var bookTitleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bookSubTitleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorsLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var publisherLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pageLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yearLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var priceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var outLinkLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var bookInfo: BookInfo? = nil
    var viewModel: BookServiceViewModelType
    init(viewModel: BookServiceViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: coder) 이것도 됨
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(bookTitleLbl)
        stackView.addArrangedSubview(bookSubTitleLbl)
        stackView.addArrangedSubview(authorsLbl)
        stackView.addArrangedSubview(publisherLbl)
        stackView.addArrangedSubview(pageLbl)
        stackView.addArrangedSubview(yearLbl)
        stackView.addArrangedSubview(ratingLbl)
        stackView.addArrangedSubview(descriptionLbl)
        stackView.addArrangedSubview(priceLbl)
        stackView.addArrangedSubview(outLinkLbl)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func configure(bookId: String) {
        binding()
        self.navigationItem.title = "상세 내역"
        viewModel.input.getBookInfo(bookId: bookId)
    }
    
    func binding() {
        viewModel.output.errorMsg
            .bind { [weak self] errMsg in
                guard let self = self else { return }
                self.showAlert(withTitle: "Error 발생", withMessage: errMsg)
            }
        
        viewModel.output.bookInfo
            .bind { [weak self] bookInfo in
                guard let self = self else { return }
                self.bookInfo = bookInfo
                self.getImage(image: bookInfo?.image)
                
                DispatchQueue.main.async {
                    self.bookTitleLbl.text = "Title : \(bookInfo?.title ?? "")"
                    self.bookSubTitleLbl.text = "subTitle : \(bookInfo?.subtitle ?? "")"
                    self.authorsLbl.text = "author : \(bookInfo?.authors ?? "")"
                    self.publisherLbl.text = "publisher : \(bookInfo?.publisher ?? "")"
                    self.pageLbl.text = "pages : \(bookInfo?.pages ?? "")"
                    self.yearLbl.text = "year : \(bookInfo?.year ?? "")"
                    self.ratingLbl.text = "rating \(bookInfo?.rating ?? "")"
                    self.descriptionLbl.text = "description \(bookInfo?.desc ?? "")"
                    self.priceLbl.text = "price : \(bookInfo?.price ?? "")"
                    self.outLinkLbl.text = "link : \(bookInfo?.url ?? "")"
                    
                    if let pdfDictionary = bookInfo?.pdf {
                        if pdfDictionary.count > 0 {
                            for url in pdfDictionary.values {
                                let pdfView = PDFView()
                                pdfView.translatesAutoresizingMaskIntoConstraints = false
                                self.stackView.addArrangedSubview(pdfView)
                                NSLayoutConstraint.activate([
                                    pdfView.heightAnchor.constraint(equalToConstant: 250),
                                    pdfView.widthAnchor.constraint(equalToConstant: 250),
                                ])
                                
                                DispatchQueue.global().async {
                                    if let url = URL(string: url), let document = PDFDocument(url: url) {
                                        DispatchQueue.main.async {
                                            pdfView.autoScales = true
                                            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                            pdfView.displayDirection = .horizontal
                                            pdfView.document = document
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.view.layoutIfNeeded()
                }
            }
    }
    
    func getImage(image: String?) {
        if let image = image {
            guard let imageUrl = URL(string: image) else { return }
            imageView.load(url: imageUrl)
        }
    }
}
