import UIKit

class HomeScreenViewController : UIViewController, Subscriber, Trackable {
    
    var primaryWalletManager: BTCWalletManager? {
        didSet {
            setInitialData()
            setupSubscriptions()
            assetList.reload()
            attemptShowPrompt()
        }
    }
    private let assetList = AssetListTableView()
    private let subHeaderView = UIView()
    let logoView = UIImageView(image: UIImage(named: "logo"))
    private let total = UILabel(font: .customBold(size: 30.0), color: .black)
    private let totalHeader = UILabel(font: .customBody(size: 12.0), color: .black)
    private let prompt = UIView()
    private var promptHiddenConstraint: NSLayoutConstraint!

    var didSelectCurrency : ((CurrencyDef) -> Void)?
    var didTapAddWallet: (() -> Void)?
    var didTapBuy: (() -> Void)?
    var didTapTrade: (() -> Void)?
    var didTapMenu: (() -> Void)?

    // MARK: -
    
    init(primaryWalletManager: BTCWalletManager?) {
        self.primaryWalletManager = primaryWalletManager
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        assetList.didSelectCurrency = didSelectCurrency
        assetList.didTapAddWallet = didTapAddWallet
        addSubviews()
        addConstraints()
        setInitialData()
        setupSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + promptDelay) { [weak self] in
            self?.attemptShowPrompt()
        }
        updateTotalAssets()
    }
    
    // MARK: Setup

    private func addSubviews() {
        view.addSubview(subHeaderView)
        subHeaderView.addSubview(totalHeader)
        subHeaderView.addSubview(total)
        subHeaderView.addSubview(logoView)
        view.addSubview(prompt)
    }

    private func addConstraints() {
        let headerHeight: CGFloat = 46.0

        subHeaderView.constrain([
            subHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            subHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subHeaderView.heightAnchor.constraint(equalToConstant: headerHeight) ])
        
        logoView.constrain([
            logoView.leadingAnchor.constraint(equalTo: subHeaderView.leadingAnchor, constant: C.padding[2]),
            logoView.bottomAnchor.constraint(equalTo: subHeaderView.bottomAnchor, constant: -C.padding[2]),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 230.0/772.0)
            ])
        
        total.constrain([
            total.trailingAnchor.constraint(equalTo: subHeaderView.trailingAnchor, constant: -C.padding[2]),
            total.centerYAnchor.constraint(equalTo: logoView.centerYAnchor)
            ])
        totalHeader.constrain([
            totalHeader.trailingAnchor.constraint(equalTo: total.trailingAnchor),
            totalHeader.bottomAnchor.constraint(equalTo: total.topAnchor, constant: 0.0)
            ])
        
        promptHiddenConstraint = prompt.heightAnchor.constraint(equalToConstant: 0.0)
        prompt.constrain([
            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prompt.topAnchor.constraint(equalTo: subHeaderView.bottomAnchor),
            promptHiddenConstraint
            ])
        
        addChildViewController(assetList, layout: {
            assetList.view.constrain([
                assetList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                assetList.view.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: C.padding[1]),
                assetList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                assetList.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        })
    }

    private func setInitialData() {
        view.backgroundColor = .white
        subHeaderView.backgroundColor = .white
        subHeaderView.clipsToBounds = false
        
        navigationItem.titleView = UIView()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "TransparentPixel"), for: .default)
        
        totalHeader.text = S.HomeScreen.totalAssets
        totalHeader.textColor = .black
        totalHeader.textAlignment = .left
        total.textAlignment = .left
        total.text = "0"
        title = ""
        
        updateTotalAssets()
    }
    
    private func setupSubscriptions() {
        Store.unsubscribe(self)
        
        Store.subscribe(self, selector: {
            var result = false
            let oldState = $0
            let newState = $1
            $0.displayCurrencies.forEach { currency in
                result = result || oldState[currency]?.balance != newState[currency]?.balance
                result = result || oldState[currency]?.currentRate?.rate != newState[currency]?.currentRate?.rate
            }
            return result
        },
                        callback: { _ in
                            self.updateTotalAssets()
        })
        
        // prompts
        Store.subscribe(self, name: .didUpgradePin, callback: { _ in
            if self.currentPrompt?.type == .upgradePin {
                self.currentPrompt = nil
            }
        })
        Store.subscribe(self, name: .didEnableShareData, callback: { _ in
            if self.currentPrompt?.type == .shareData {
                self.currentPrompt = nil
            }
        })
        Store.subscribe(self, name: .didWritePaperKey, callback: { _ in
            if self.currentPrompt?.type == .paperKey {
                self.currentPrompt = nil
            }
        })
    }
    
    private func updateTotalAssets() {
        let fiatTotal: Decimal = Store.state.displayCurrencies.map {
            guard let balance = Store.state[$0]?.balance,
                let rate = Store.state[$0]?.currentRate else { return 0.0 }
            let amount = Amount(amount: balance,
                                currency: $0,
                                rate: rate)
            return amount.fiatValue
            }.reduce(0.0, +)
        let format = NumberFormatter()
        format.isLenient = true
        format.numberStyle = .currency
        format.generatesDecimalNumbers = true
        format.negativeFormat = format.positiveFormat.replacingCharacters(in: format.positiveFormat.range(of: "#")!, with: "-#")
        format.currencySymbol = Store.state[Currencies.btc]?.currentRate?.currencySymbol ?? ""
        self.total.text = format.string(from: fiatTotal as NSDecimalNumber)
    }
    
    // MARK: Actions
    
    @objc private func buy() {
        saveEvent("currency.didTapBuyBitcoin", attributes: [:])
        didTapBuy?()
    }
    
    @objc private func trade() {
        saveEvent("currency.didTapTrade", attributes: [:])
        didTapTrade?()
    }
    
    @objc private func menu() { didTapMenu?() }
    
    // MARK: - Prompt
    
    private let promptDelay: TimeInterval = 0.6
    
    private var currentPrompt: Prompt? {
        didSet {
            if currentPrompt != oldValue {
                var afterFadeOut: TimeInterval = 0.0
                if let oldPrompt = oldValue {
                    afterFadeOut = 0.15
                    UIView.animate(withDuration: 0.2, animations: {
                        oldValue?.alpha = 0.0
                    }, completion: { _ in
                        oldPrompt.removeFromSuperview()
                    })
                }
                
                if let newPrompt = currentPrompt {
                    newPrompt.alpha = 0.0
                    prompt.addSubview(newPrompt)
                    newPrompt.constrain(toSuperviewEdges: .zero)
                    prompt.layoutIfNeeded()
                    promptHiddenConstraint.isActive = false

                    // fade-in after fade-out and layout
                    UIView.animate(withDuration: 0.2, delay: afterFadeOut + 0.15, options: .curveEaseInOut, animations: {
                        newPrompt.alpha = 1.0
                    })
                } else {
                    promptHiddenConstraint.isActive = true
                }
                
                // layout after fade-out
                UIView.animate(withDuration: 0.2, delay: afterFadeOut, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    private func attemptShowPrompt() {
        guard let walletManager = primaryWalletManager else {
            currentPrompt = nil
            return
        }
        if let type = PromptType.nextPrompt(walletManager: walletManager) {
            self.saveEvent("prompt.\(type.name).displayed")
            currentPrompt = Prompt(type: type)
            currentPrompt!.dismissButton.tap = { [unowned self] in
                self.saveEvent("prompt.\(type.name).dismissed")
                self.currentPrompt = nil
            }
            currentPrompt!.continueButton.tap = { [unowned self] in
                // TODO:BCH move out of home screen
                if let trigger = type.trigger(currency: Currencies.btc) {
                    Store.trigger(name: trigger)
                }
                self.saveEvent("prompt.\(type.name).trigger")
                self.currentPrompt = nil
            }
            if type == .biometrics {
                UserDefaults.hasPromptedBiometrics = true
            }
            if type == .shareData {
                UserDefaults.hasPromptedShareData = true
            }
        } else {
            currentPrompt = nil
        }
    }
    
    // MARK: -

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
