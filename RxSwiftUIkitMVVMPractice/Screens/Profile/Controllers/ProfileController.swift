//
//  ProfileController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/21.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    
    var vm = ProfileViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        navigationItem.title = "설정"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEditProfile))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(ProfileHeader.self,
                           forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.rowHeight = 50
    }
    
    // MARK: - Actions
    
    @objc func handleEditProfile() {
        print("편집 눌렀습니다.")
    }
}

// MARK: - TableViewDataSource

extension ProfileController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        switch indexPath.section {
        case 0:
            cell.configure(with: vm.tableCellList[0])
        case 1:
            cell.configure(with: vm.tableCellList[indexPath.row + 1])
        case 2:
            cell.configure(with: vm.tableCellList[indexPath.row + 4])
        default:
            break
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        
        return 200
    }
}
