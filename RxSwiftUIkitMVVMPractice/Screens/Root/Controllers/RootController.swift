//
//  RootViewController.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import UIKit
import RxSwift

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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSerachController()
        configureUI()
        addSubscribers()
    }
    
    // MARK: - API
    
    func addSubscribers() {
        vm.volumeRelay
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
}

// MARK: - UICollectionViewDataSource

extension RootController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? vm.filterdCoins.count : vm.volume.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TickerCell
        let coin = inSearchMode ? vm.filterdCoins[indexPath.row] : vm.volume[indexPath.row]
        
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
        let coins = vm.volume.filter({
            $0.symbol.lowercased().contains(searchText) || $0.koreanName.contains(searchText) || $0.englishName.lowercased().contains(searchText)
        })
        vm.filterdRelay.accept(coins)
        
        self.collectionView.reloadData()
    }
}