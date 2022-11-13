//
//  SearchBookTableViewCell.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.isOpaque = true
        return imgView
    }()
    
    lazy var bookNameLbl: UILabel = {
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
    
    lazy var priceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
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
    
    let contentStack: UIStackView = {
        var view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.alignment = .center
        return view }()
    
    let labelStack: UIStackView = {
        var view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        return view }()
    
    private var profileImageWidth : CGFloat = 42
    private var book: Book!
    static let identifier = "SearchBookTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func configure(book: Book){
        self.book = book
        getImage(image: book.image)
        bookNameLbl.text = book.title
        bookSubTitleLbl.text = book.subtitle
        priceLbl.text = book.price
        descriptionLbl.text = book.url
    }
    
    func getImage(image: String?) {
        if let image = image {
            guard let imageUrl = URL(string: image) else { return }
            imgView.load(url: imageUrl)
        }
    }
    
    fileprivate func setupView(){
        contentView.addSubview(contentStack)
        labelStack.addArrangedSubview(bookNameLbl)
        labelStack.addArrangedSubview(bookSubTitleLbl)
        labelStack.addArrangedSubview(priceLbl)
        labelStack.addArrangedSubview(descriptionLbl)
        contentStack.addArrangedSubview(imgView)
        contentStack.addArrangedSubview(labelStack)
        
        NSLayoutConstraint.activate([
            
            imgView.heightAnchor.constraint(equalToConstant: 80),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgView.image = nil
    }

}
