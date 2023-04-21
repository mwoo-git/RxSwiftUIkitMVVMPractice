//
//  ChatController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ChatController: UITableViewController {
    
    // MARK: - Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Ligecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSerachController()
        configureTableView()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        navigationItem.title = "대화"
        view.backgroundColor = .white
        tableView.register(ChatCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSerachController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "대화 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - API
    
    // MARK: - Actions
}

// MARK: TableViewDataSource

extension ChatController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        
        return cell
    }
}

// MARK: - TableViewDelegate

extension ChatController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("셀을 선택했습니다.")
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}

// MARK: - UISearchResultsUpdating

extension ChatController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        print(searchText)
        
        self.tableView.reloadData()
    }
}
