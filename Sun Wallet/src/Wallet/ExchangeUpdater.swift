import Foundation

class ExchangeUpdater : Subscriber {

    let currencies: [CurrencyDef]
    
    //MARK: - Public
    init(currencies: [CurrencyDef], apiClient: BRAPIClient) {
        self.currencies = currencies
        self.apiClient = apiClient
        currencies.forEach { currency in
            Store.subscribe(self,
                            selector: { $0.defaultCurrencyCode != $1.defaultCurrencyCode },
                            callback: { state in
                                guard let currentRate = state[currency]!.rates.first( where: { $0.code == state.defaultCurrencyCode }) else { return }
                                Store.perform(action: WalletChange(currency).setExchangeRate(currentRate))
            })
        }
    }

    func refresh(completion: @escaping () -> Void) {
        // get btc/fiat rates
        apiClient.bitcoinExchangeRates() { [weak self] result in
            guard let `self` = self,
                case .success(let btcFiatRates) = result else { return }
            
            Store.perform(action: WalletChange(Currencies.btc).setExchangeRates(currentRate: self.findCurrentRate(rates: btcFiatRates), rates: btcFiatRates))
            
            // get token/btc rates
            self.apiClient.tokenExchangeRates() { [weak self] result in
                guard let `self` = self,
                    case .success(let tokenBtcRates) = result else { return }
                
                // calculate token/fiat rates
                var tokenBtcDict = [String: Double]()
                tokenBtcRates.forEach { tokenBtcDict[$0.reciprocalCode] = $0.rate }
                tokenBtcDict["sun"] = 0.000354677142
                Store.state.currencies.filter({ !$0.matches(Currencies.btc) }).forEach { currency in
                    print(currency.name)
                    guard let tokenBtcRate = tokenBtcDict[currency.code.lowercased()] else { return }
                    let fiatRates: [Rate] = btcFiatRates.map { btcFiatRate in
                        let tokenFiatRate = btcFiatRate.rate * tokenBtcRate
                        return Rate(code: btcFiatRate.code, name: btcFiatRate.name, rate: tokenFiatRate, reciprocalCode: currency.code.lowercased())
                    }
                    print("tokenBtcDict")
                    print(tokenBtcDict)

                    Store.perform(action: WalletChange(currency).setExchangeRates(currentRate: self.findCurrentRate(rates: fiatRates), rates: fiatRates))
                }
            }
        }
    }

    private func findCurrentRate(rates: [Rate]) -> Rate {
        guard let currentRate = rates.first( where: { $0.code == Store.state.defaultCurrencyCode }) else {
            Store.perform(action: DefaultCurrency.setDefault(C.usdCurrencyCode))
            return rates.first( where: { $0.code == C.usdCurrencyCode })!
        }
        return currentRate
    }

    //MARK: - Private
    let apiClient: BRAPIClient
}
