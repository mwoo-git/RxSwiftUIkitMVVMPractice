//
//  rootHeader.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/15.
//

import UIKit

class RootHeader: UICollectionReusableView {
    // MARK: - Properties
    
    private let totalBuyTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "총 매수"
        return label
    }()
    
    private let totalBuylabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "1,148,426"
        return label
    }()
    
    private let totalValueTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "총 평가"
        return label
    }()
    
    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "1,354,844"
        return label
    }()
    
    private let pnlTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "평가손익"
        return label
    }()
    
    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "206,251"
        return label
    }()
    
    private let returnRateTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "수익률"
        return label
    }()
    
    private let returnRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "17.91%"
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configureUI() {
        backgroundColor = .white
        
        
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
}
