//
//  SettingsRecoveryPhrasePresenter.swift
//  Tonkeeper
//
//  Created by Grigory on 11.10.23..
//

import Foundation
import WalletCore

final class SettingsRecoveryPhrasePresenter {
  
  // MARK: - Module
  
  weak var viewInput: SettingsRecoveryPhraseViewInput?
  weak var output: SettingsRecoveryPhraseModuleOutput?
  
  // MARK: - Dependencies
  
  private let keeperController: KeeperController
  
  // MARK: - Init
  
  init(keeperController: KeeperController) {
    self.keeperController = keeperController
  }
}

// MARK: - SettingsRecoveryPhrasePresenterIntput

extension SettingsRecoveryPhrasePresenter: SettingsRecoveryPhrasePresenterInput {
  func viewDidLoad() {
    updateView()
  }
}

// MARK: - SettingsRecoveryPhraseModuleInput

extension SettingsRecoveryPhrasePresenter: SettingsRecoveryPhraseModuleInput {}

// MARK: - Private

private extension SettingsRecoveryPhrasePresenter {
  func updateView() {
    let title = String.title
      .attributed(with: .h2, alignment: .center, color: .Text.primary)
    let description = String.description
      .attributed(with: .body1, alignment: .center, color: .Text.secondary)
    
    var wordViewModels = [RecoveryPhraseWordView.Model]()
    do {
      let wallet = try keeperController.activeWallet
      let mnemonic = try keeperController.getWalletMnemonic(wallet)
      wordViewModels = mnemonic
        .enumerated()
        .map {
          .init(orderNumber: $0.offset + 1, word: $0.element)
        }
    } catch {}
    
    let model = SettingsRecoveryPhraseView.Model(
      scrollContainerModel: .init(
        title: title,
        description: description), phraseListViewModel: .init(wordModels: wordViewModels))
    viewInput?.update(with: model)
  }
}

private extension String {
  static let title = "Your recovery phrase"
  static let description = "Write down these 24 words in the order given below and store them in a secret, safe place."
}