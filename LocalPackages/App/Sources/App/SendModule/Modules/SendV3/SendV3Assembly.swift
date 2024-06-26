import Foundation
import TKCore
import KeeperCore

struct SendV3Assembly {
  private init() {}
  static func module(sendItem: SendItem,
                     recipient: Recipient?, 
                     coreAssembly: TKCore.CoreAssembly,
                     keeperCoreMainAssembly: KeeperCore.MainAssembly) -> MVVMModule<SendV3ViewController, SendV3ModuleOutput, SendV3ModuleInput> {
    let viewModel = SendV3ViewModelImplementation(
      sendItem: sendItem,
      recipient: recipient,
      sendController: keeperCoreMainAssembly.sendV3Controller(),
      walletsStore: keeperCoreMainAssembly.walletAssembly.walletStore
    )
    let viewController = SendV3ViewController(viewModel: viewModel)
    return .init(view: viewController, output: viewModel, input: viewModel)
  }
}
