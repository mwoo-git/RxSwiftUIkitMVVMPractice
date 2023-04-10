//
//  RootViewModel.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import Foundation
import RxSwift
import RxCocoa

struct RootViewModel {
    
    let winnersRelay = BehaviorRelay<[TickerViewModel]>(value: [])
    let lossersRelay = BehaviorRelay<[TickerViewModel]>(value: [])
    let volumeRelay = BehaviorRelay<[TickerViewModel]>(value: [])
    
    var winners: [TickerViewModel] { winnersRelay.value }
    var lossers: [TickerViewModel] { lossersRelay.value }
    var volume: [TickerViewModel] { volumeRelay.value }
    
    private let dataService = UpbitRestApiService.shared
    private let disposeBag = DisposeBag()
    
    init() {
        fetchTickersFromRestApi()
    }
    
    func fetchTickersFromRestApi() {
        dataService.tickersSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { tickers in
                Task {
                    await self.updateWinners(tickers: tickers)
                    await self.updateLossers(tickers: tickers)
                    await self.updateVolume(tickers: tickers)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateWinners(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        let viewModels = newArray.map { TickerViewModel(ticker: $0) }
        
        await MainActor.run {
            self.winnersRelay.accept(viewModels)
        }
    }
    
    private func updateLossers(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        let viewModels = newArray.map { TickerViewModel(ticker: $0) }
        
        await MainActor.run {
            self.lossersRelay.accept(viewModels)
        }
    }
    
    private func updateVolume(tickers: [String: UpbitTicker]) async {
        let newArray = tickers.values.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        let viewModels = newArray.map { TickerViewModel(ticker: $0) }
        
        await MainActor.run {
            self.volumeRelay.accept(viewModels)
        }
    }
}
