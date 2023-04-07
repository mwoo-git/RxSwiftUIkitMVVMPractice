//
//  UpbitRestApi.swift
//  RxSwiftUIkitMVVMPractice
//
//  Created by Woo Min on 2023/04/05.
//

import Foundation

class UpbitRestApiService {
    
    static let shared = UpbitRestApiService()
    
    @Published var coins = [UpbitCoin]()
    @Published var tickers = [String: UpbitTicker]()
    
    private let baseUrl = "https://api.upbit.com/v1"
    
    private init() {
        Task {
            await fetchCoins()
        }
    }
    
    func fetchCoins() async {
        let request = URLRequest(url: URL(string: "\(baseUrl)/market/all")!)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                print("Error fetching upbit coins")
                return
            }
            let coins = try JSONDecoder().decode([UpbitCoin].self, from: data).filter { $0.market.hasPrefix("KRW") }
            self.coins = coins
            await fetchTickers()
        } catch {
            print("Error fetching upbit coins: \(error)")
        }
    }
    
    func fetchTickers() async {
        let tickersUrl = "https://api.upbit.com/v1/ticker?markets=" + coins.map { $0.market }.joined(separator: ",")
        let request = URLRequest(url: URL(string: tickersUrl)!)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                print("Error fetching upbit tickers")
                return
            }
            let tickersRestAPI = try JSONDecoder().decode([UpbitTickerRestAPI].self, from: data)
            var tickersDict = [String: UpbitTicker]()
            tickersRestAPI.forEach { tickerRestAPI in
                let ticker = UpbitTicker(market: tickerRestAPI.market,
                                         change: tickerRestAPI.change,
                                         tradePrice: tickerRestAPI.tradePrice,
                                         changeRate: tickerRestAPI.changeRate,
                                         accTradePrice24H: tickerRestAPI.accTradePrice24H,
                                         signedChangeRate: tickerRestAPI.signedChangeRate)
                tickersDict[ticker.market] = ticker
            }
            self.tickers = tickersDict
        } catch {
            print("Error fetching upbit tickers: \(error)")
        }
    }
}
