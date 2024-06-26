import TKUIKit
import TKCoordinator
import TKCore
import KeeperCore

struct HistoryModule {
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  func createHistoryCoordinator() -> HistoryCoordinator {
    let navigationController = TKNavigationController()
    navigationController.configureTransparentAppearance()
    navigationController.setNavigationBarHidden(true, animated: false)
    
    let coordinator = HistoryCoordinator(
      router: NavigationControllerRouter(
        rootViewController: navigationController
      ),
      coreAssembly: dependencies.coreAssembly,
      keeperCoreMainAssembly: dependencies.keeperCoreMainAssembly
    )
    return coordinator
  }
  
  func createTonHistoryListModule(wallet: Wallet) -> MVVMModule<HistoryListViewController, HistoryListModuleOutput, HistoryListModuleInput> {
    HistoryListAssembly.module(
      historyListController: dependencies.keeperCoreMainAssembly.tonEventsHistoryListController(wallet: wallet),
      historyEventMapper: HistoryEventMapper(
        accountEventActionContentProvider: HistoryListAccountEventActionContentProvider()
      )
    )
  }
  
  func createJettonHistoryListModule(
    jettonItem: JettonItem,
    wallet: Wallet
  ) -> MVVMModule<HistoryListViewController, HistoryListModuleOutput, HistoryListModuleInput> {
    HistoryListAssembly.module(
      historyListController: dependencies.keeperCoreMainAssembly.jettonEventsHistoryListController(
        jettonItem: jettonItem,
        wallet: wallet
      ),
      historyEventMapper: HistoryEventMapper(
        accountEventActionContentProvider: HistoryListAccountEventActionContentProvider()
      )
    )
  }
}

extension HistoryModule {
  struct Dependencies {
    let coreAssembly: TKCore.CoreAssembly
    let keeperCoreMainAssembly: KeeperCore.MainAssembly
    
    public init(coreAssembly: TKCore.CoreAssembly,
                keeperCoreMainAssembly: KeeperCore.MainAssembly) {
      self.coreAssembly = coreAssembly
      self.keeperCoreMainAssembly = keeperCoreMainAssembly
    }
  }
}
