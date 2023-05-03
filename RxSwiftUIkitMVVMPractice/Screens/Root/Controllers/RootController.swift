//
//  RootViewController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import UIKit
import RxSwift
import Firebase

private let reuseIdentifier = "CoinCell"
private let headerIdentifier = "CoinHeader"

class RootController: UICollectionViewController {
    
    // MARK: Properties
    
    private var vm = RootViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private var sort = 0 {
        didSet { collectionView.reloadData()}
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSortMenu()
        configureSerachController()
        configureUI()
        bind()
    }
    
    // MARK: - API
    
    func bind() {
        vm.volume
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configures
    
    func configureUI() {
        navigationItem.title = "거래소"
        view.backgroundColor = .white
        
        collectionView.register(TickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(RootHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    // MARK: - Helpers
    
    func configureSerachController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "코인명/심볼 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    func configureSortMenu() {
        let volumeAction = UIAction(title: "거래량") { _ in
            guard self.sort != 0 else { return }
            self.sort = 0
        }
        
        let winnersAction = UIAction(title: "상승") { _ in
            guard self.sort != 1 else { return }
            self.sort = 1
        }
        
        let lossersAction = UIAction(title: "하락") { _ in
            guard self.sort != 2 else { return }
            self.sort = 2
        }
        
        let menu = UIMenu(title: "", children: [volumeAction, winnersAction, lossersAction])
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: nil)
        sortButton.menu = menu
        
        navigationItem.leftBarButtonItem = sortButton
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue
    }
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDataSource

extension RootController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? vm.filterd.value.count : vm.volume.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TickerCell
        
        let sort = sort == 0 ? vm.volume.value[indexPath.row] : sort == 1 ? vm.winners.value[indexPath.row] : vm.lossers.value[indexPath.row]
        
        let coin = inSearchMode ? vm.filterd.value[indexPath.row] : sort
        
        cell.configure(with: coin)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! RootHeader
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension RootController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !inSearchMode else { return }
        searchController.dismiss(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RootController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }
}

// MARK: - UISearchResultsUpdating

extension RootController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        let coins = vm.volume.value.filter({
            $0.symbol.lowercased().contains(searchText) || $0.koreanName.contains(searchText) || $0.englishName.lowercased().contains(searchText)
        })
        vm.filterd.accept(coins)
        
        self.collectionView.reloadData()
    }
}
