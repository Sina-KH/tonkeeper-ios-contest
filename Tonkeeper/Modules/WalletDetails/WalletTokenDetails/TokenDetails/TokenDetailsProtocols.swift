//
//  TokenDetailsTokenDetailsProtocols.swift
//  Tonkeeper

//  Tonkeeper
//  Created by Grigory Serebryanyy on 13/07/2023.
//

import Foundation
import WalletCore

protocol TokenDetailsModuleOutput: AnyObject {
  func didTapTonSend()
  func didTapTonReceive()
  func didTapTonBuy()
  func didTapTopSwap()
  
  func didTapTokenSend(tokenInfo: TokenInfo)
  func didTapTokenReceive(tokenInfo: TokenInfo)
  func didTapTokenSwap(tokenInfo: TokenInfo)
}

protocol TokenDetailsModuleInput: AnyObject, TokenDetailsControllerOutput {}

protocol TokenDetailsPresenterInput {
  func viewDidLoad()
  func didPullToRefresh()
}

protocol TokenDetailsViewInput: AnyObject {
  func updateTitle(title: String)
  func updateHeader(model: TokenDetailsHeaderView.Model)
  func stopRefresh()
}