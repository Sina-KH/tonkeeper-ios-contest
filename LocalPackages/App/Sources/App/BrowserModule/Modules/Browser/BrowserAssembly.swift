import Foundation
import TKCore
import KeeperCore

struct BrowserAssembly {
  private init() {}
  static func module(keeperCoreAssembly: KeeperCore.MainAssembly)
  -> MVVMModule<BrowserViewController, BrowserModuleOutput, Void> {
    
    let exploreModule = BrowserExploreAssembly.module(keeperCoreAssembly: keeperCoreAssembly)

    let viewModel = BrowserViewModelImplementation(exploreModuleOutput: exploreModule.output)
    let viewController = BrowserViewController(
      viewModel: viewModel,
      exploreViewController: exploreModule.view
    )
    return .init(view: viewController, output: viewModel, input: Void())
  }
}
