//
//  RootViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import Foundation
import Combine
import RxSwift

class RootViewModel {
    
    @Published var winners = [UpbitTicker]()
    @Published var lossers = [UpbitTicker]()
    @Published var volume = [UpbitTicker]()
    
    @Published var winnerList = [TickerViewModel]()
    
    private let dataService = UpbitRestApiService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTickersFromRestApi()
    }
    
    func fetchTickersFromRestApi() {
        dataService.$tickers
            .sink { tickers in
                Task {
                    await self.updateWinners(tickers: tickers)
                    await self.updateLossers(tickers: tickers)
                    await self.updateVolume(tickers: tickers)
                    self.winnerList = self.winners.map { TickerViewModel(ticker: $0) }
                    print(self.winnerList)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateWinners(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        
        await MainActor.run {
            self.winners = newArray
        }
    }
    
    private func updateLossers(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        
        await MainActor.run {
            self.lossers = newArray
        }
    }
    
    private func updateVolume(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        
        await MainActor.run {
            self.volume = newArray
        }
    }
}
