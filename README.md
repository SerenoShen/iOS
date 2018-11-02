[![Sun Wallet](/images/top-logo.jpg)](https://itunes.apple.com/app/breadwallet/id885251393)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

## Your all-in-one Crypto Wallet

Sun Wallet lets you manage all your cryptocurrencies in one, secure and simple-to-use iOS App. Used by millions of people worldwide.

### Completely decentralized

Unlike other iOS bitcoin wallets, **Sun Wallet** is a standalone bitcoin client. It connects directly to the bitcoin network using [SPV](https://en.bitcoin.it/wiki/Thin_Client_Security#Header-Only_Clients) mode, and doesn't rely on servers that can be hacked or disabled.

### Cutting-edge security

**Sun Wallet** utilizes AES hardware encryption, app sandboxing, and the latest iOS security features to protect users from malware, browser security holes, and even physical theft. Private keys are stored only in the secure enclave of the user's phone, inaccessible to anyone other than the user.

### Desgined with new users in mind

Simplicity and ease-of-use is **Bread**'s core design principle. A simple recovery phrase (which we call a paper key) is all that is needed to restore the user's wallet if they ever lose or replace their device. **Bread** is [deterministic](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki), which means the user's balance and transaction history can be recovered just from the paper key.

![screenshots](/images/screenshots.jpg)

### Features

- [Simplified payment verification](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki) for fast mobile performance
- No server to get hacked or go down
- Single paper key is all that's needed to backup your wallet
- Private keys never leave your device
- Save a memo for each transaction (off-chain)
- Supports importing [password protected](https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki) paper wallets
- Supports ["Payment protocol"](https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki) payee identity certification

### Localization
**Sun Wallet** is available in the following languages:

- English
- German
- Korean

You can help us translate Sun Wallet into more languages here:

[Lokalise](https://phraseapp.com)


### WARNING:
***Installation on jailbroken devices is strongly discouraged.***

Any jailbreak app can grant itself access to every other app's keychain data. This means it can access your wallet and steal your cryptocurrency by self-signing as described [here](http://www.saurik.com/id/8) and including `<key>application-identifier</key><string>*</string>` in its .entitlements file.

---

## Screenshots
![Screenshots](screenshots.png)


##Pull Requests
If you want to help improve Sun Wallet, please do so in the form of a Pull Request. When creating a PR, you will be asked to agree to the Contributor License Agreement (CLA).

## How to Install - iOS

You need Xcode 10 or later. And an iOS device running at least iOS 12.

###Step 1
Open a new terminal window in OS X. Refer to [this guide](http://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line) on using the OS X Terminal.

```bash
git clone https://github.com/sunwallet/iOS.git
```

###Step 2
```bash
cd Starglobe/apps/star3map/iphone
```

###Step 3
For this step you will need to have Cocoapods installed. (How to install Cocoapods: [https://cocoapods.org](https://cocoapods.org))

Delete `Sun Wallet.xcworkspace` and then run this command:
```bash
pod install
```

###Step 4
Open `Starglobe.xcworkspace` in Xcode.

###Step 5
Open the file Keys.swift and fill in API Keys for all 3rd party SDKs. You will have to register for all services on the list.

###Step 6
Build and run the application.

- When running this application on a device you will need to add a signing profile in the project's Build Settings.


##License
Sun Wallet is licensed under the [GNU Affero General Public License v3.0](/LICENSE)

**Sun Wallet** is open source and available under the terms of the MIT license.

Source code is available at https://github.com/sunwallet


##Donate
If you enjoy Sun Wallet and want to support the further development of the app, you can do so by donating cryptocurrency to one of the following addresses. Thank you so much!

- Bitcoin: 3AoXrR1Dd2g6m9E96uMSbFNe2Z8DH7xXJH
- Bitcoin Cash: 
- Ethereum: 0x5d27f70bDF90Ce9b73D303187bd0bF1a65528eBd
- Ripple: rL7dzkNa26R9XtSQfgnKtCGnUwDN5b23Vn
- Monero: 