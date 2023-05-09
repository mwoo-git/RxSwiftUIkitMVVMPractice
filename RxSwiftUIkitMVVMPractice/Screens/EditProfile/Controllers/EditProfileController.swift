//
//  EditProfileController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/05/03.
//

import UIKit
import RxSwift

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class EditProfileController: UITableViewController {
    // MARK: - Properties
    
    private var vm = EditProfileViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        navigationItem.title = "프로필 수정"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancelEditing))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleEndEditing))
        navigationItem.leftBarButtonItem?.tintColor = .black;        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(EditProfileHeader.self,
                           forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.rowHeight = 50
    }
    
    // MARK: - Actions
    
    @objc func handleEndEditing() {
        print("handleEndEditing")
    }
    
    @objc func handleCancelEditing() {
        print("handleCancelEditing")
    }
    
}

// MARK: - TableViewDataSource

extension EditProfileController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EditProfileCell
        switch indexPath.section {
        case 0:
            cell.configure(withData: vm.tableCellList[indexPath.row])
        default:
            break
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        
        return 170
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let controller = EditNameController()
                navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller = EditUserNameController()
                navigationController?.pushViewController(controller, animated: true)
            case 2:
                let controller = EditDescriptionController()
                navigationController?.pushViewController(controller, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
