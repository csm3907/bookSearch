//
//  ViewController.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 70)
        return spinner
    }()
    
    lazy var tbview: UITableView = {
        let tbview = UITableView()
        tbview.translatesAutoresizingMaskIntoConstraints = false
        tbview.keyboardDismissMode = .onDrag
        tbview.tableFooterView = spinner
        tbview.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        tbview.frame = self.view.bounds
        //tbview.separatorStyle = .none
        tbview.translatesAutoresizingMaskIntoConstraints = false
        tbview.estimatedRowHeight = 500
        tbview.rowHeight = UITableView.automaticDimension
        tbview.delegate = self
        tbview.dataSource = self
        return tbview
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    var searchString: String = ""
    var isDataLoading: Bool = false
    var pageNo:Int = 0
    var dataSources: [Book] = []
    let viewModel: BookServiceViewModelType = BookServiceViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        binding()
    }
    
    private func setupView() {
        navigationItem.titleView = searchBar
        view.addSubview(tbview)
        
        let margins = view.layoutMarginsGuide
        tbview.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tbview.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tbview.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tbview.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func binding() {
        viewModel.output.bookList
            .bind { [weak self] list in
                guard let self = self else { return }
                guard list?.count ?? 0 > 0 else { return }
                self.isDataLoading = false
                
                if self.pageNo == 0 {
                    self.dataSources = list ?? []
                    DispatchQueue.main.async {
                        self.tbview.reloadData()
                    }
                } else {
                    let pCnt = self.dataSources.count
                    list?.forEach({ book in
                        self.dataSources.append(book)
                    })
                    DispatchQueue.main.async {
                        self.tbview.insertRows(pCnt, self.dataSources.count)
                        self.spinner.stopAnimating()
                    }
                }
            }
        
        viewModel.output.errorMsg
            .bind { [weak self] errMsg in
                guard let self = self else { return }
                self.showAlert(withTitle: "Error 발생", withMessage: errMsg)
            }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBookTableViewCell.identifier, for: indexPath) as? SearchBookTableViewCell else { return UITableViewCell() }
        let book = dataSources[indexPath.row]
        cell.configure(book: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bookId = dataSources[indexPath.row].isbn13 else { return }
        let childVC = DetailViewController(viewModel: viewModel)
        childVC.configure(bookId: bookId)
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        guard searchString.count > 0 else { return }
        if ((tbview.contentOffset.y + tbview.frame.size.height) >= tbview.contentSize.height)
        {
            if !isDataLoading {
                isDataLoading = true
                pageNo += 1
                spinner.startAnimating()
                viewModel.input.getBookSearchList(bookName: searchString, page: pageNo)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search 시작 ")
        guard let searchText = searchBar.text else { return }
        self.searchString = searchText
        searchBar.resignFirstResponder()
        viewModel.input.getBookSearchList(bookName: searchText, page: 0)
    }
}
