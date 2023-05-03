//
//  RootViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import RxSwift
import RxCocoa

class RootViewModel {
    
    // MARK: - Properties
    
    let winners = BehaviorRelay<[TickerViewModel]>(value: [])
    let lossers = BehaviorRelay<[TickerViewModel]>(value: [])
    let volume = BehaviorRelay<[TickerViewModel]>(value: [])
    let filterd = BehaviorRelay<[TickerViewModel]>(value: [])
    
    var coins: [UpbitCoin]?
    var tickers: [String: UpbitTicker]?
    
    // MARK: - Init
    
    init() {
        Task {
            await fetchCoins()
            await fetchTickers()
        }
    }
    
    // MARK: - RestApi
    
    func fetchCoins() async {
        do {
            let coins = try await UpbitService.fetchCoins()
            self.coins = coins
        } catch {
            print("DEBUG: fetchCoins() Failed.")
        }
    }
    
    func fetchTickers() async {
        do {
            guard let coins = coins else { return }
            let tickers = try await UpbitService.fetchTickers(withCoins: coins)
            self.tickers = tickers
            Task { await updateWinners() }
            Task { await updateLossers() }
            Task { await updateVolume() }
        } catch {
            print("DEBUG: fetchTickers() Failed.")
        }
    }
    
    // MARK: - Array
    
    private func updateWinners() async {
        guard let tickers = tickers, let coins = coins else { return }
        
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        let viewModels = newArray.compactMap { ticker in
            if let coin = coins.first(where: { $0.market == ticker.market }) {
                return TickerViewModel(ticker: ticker, coin: coin)
            }
            return nil
        }
        
        await MainActor.run {
            self.winners.accept(viewModels)
        }
    }
    
    private func updateLossers() async {
        guard let tickers = tickers, let coins = coins else { return }
        
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        let viewModels = newArray.compactMap { ticker in
            if let coin = coins.first(where: { $0.market == ticker.market }) {
                return TickerViewModel(ticker: ticker, coin: coin)
            }
            return nil
        }
        
        await MainActor.run {
            self.lossers.accept(viewModels)
        }
    }
    
    private func updateVolume() async {
        guard let tickers = tickers, let coins = coins else { return }
        
        let newArray = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        let viewModels = newArray.compactMap { ticker in
            if let coin = coins.first(where: { $0.market == ticker.market }) {
                return TickerViewModel(ticker: ticker, coin: coin)
            }
            return nil
        }
        
        await MainActor.run {
            self.volume.accept(viewModels)
        }
    }
}
