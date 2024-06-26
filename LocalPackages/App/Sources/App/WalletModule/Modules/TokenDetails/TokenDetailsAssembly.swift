import UIKit
import TKCore
import KeeperCore

struct TokenDetailsAssembly {
  private init() {}
  static func module(
    tokenDetailsListContentViewController: TokenDetailsListContentViewController,
    tokenDetailsController: TokenDetailsController,
    chartViewControllerProvider: (() -> UIViewController?)?,
    hasAbout: Bool = false
  ) -> MVVMModule<TokenDetailsViewController, TokenDetailsModuleOutput, Void> {
    let viewModel = TokenDetailsViewModelImplementation(
      tokenDetailsController: tokenDetailsController,
      chartViewControllerProvider: chartViewControllerProvider
    )
    let viewController = TokenDetailsViewController(
      viewModel: viewModel,
      listContentViewController: tokenDetailsListContentViewController
    )
    return .init(view: viewController, output: viewModel, input: Void())
  }
}
