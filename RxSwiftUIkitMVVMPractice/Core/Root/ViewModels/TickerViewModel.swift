//
//  TickerViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import Foundation

struct TickerViewModel {
    private let ticker: UpbitTicker
    
    var market: String {
        return ticker.market
    }
    
    var price: String {
        return ticker.formattedTradePrice
    }
    
    var changeRate: String {
        return ticker.formattedChangeRate
    }
    
    var volume: String {
        return ticker.formattedAccTradePrice24H
    }
    
    var symbol: String {
        return ticker.symbol
    }
    
    init(ticker: UpbitTicker) {
        self.ticker = ticker
    }
}
