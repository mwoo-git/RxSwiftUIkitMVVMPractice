//
//  TickerCell.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import UIKit

class TickerCell: UICollectionViewCell {
    // MARK: - Properties
    
    private var vm: TickerViewModel? {
        didSet { configureLabels() }
    }
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let changeRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        
        addSubview(symbolLabel)
        symbolLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        addSubview(priceLabel)
        priceLabel.anchor(top: symbolLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 20)
        
        addSubview(changeRateLabel)
        changeRateLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 20)
        
        addSubview(volumeLabel)
        volumeLabel.anchor(top: changeRateLabel.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 20)
    }
    
    // MARK: - Helpers
    
    func configure(with vm: TickerViewModel) {
        self.vm = vm
    }
    
    func configureLabels() {
        guard let vm = vm else { return }
        
        symbolLabel.text = vm.symbol
        priceLabel.text = vm.price
        changeRateLabel.text = vm.changeRate
        volumeLabel.text = vm.volume
    }
}
