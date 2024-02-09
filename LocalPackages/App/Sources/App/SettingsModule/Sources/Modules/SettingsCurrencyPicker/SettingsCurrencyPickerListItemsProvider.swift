import UIKit
import TKUIKit
import KeeperCore

final class SettingsCurrencyPickerListItemsProvider: SettingsListItemsProvider {
  private let settingsController: SettingsController
  
  init(settingsController: SettingsController) {
    self.settingsController = settingsController
  }
  
  var didUpdateSections: (() -> Void)?
  var didSelectItem: ((SettingsListSection, Int) -> Void)?
  
  var title: String { "Primary currency" }
  
  func getSections() -> [SettingsListSection] {
    [createSection()]
  }
  
  func selectItem(section: SettingsListSection, index: Int) {
    switch section.items[index] {
    case let walletModel as WalletsListWalletCell.Model:
      walletModel.selectionHandler?()
    default:
      break
    }
  }
  
  func cell(collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: AnyHashable) -> TKCollectionViewCell? {
    nil
  }
  
  func initialSelectedIndexPath() -> IndexPath? {
    guard let index = settingsController.getAvailableCurrencies().firstIndex(of: settingsController.activeCurrency()) else {
      return nil
    }
    return IndexPath(row: index, section: 0)
  }
}

private extension SettingsCurrencyPickerListItemsProvider {
  func createSection() -> SettingsListSection {
    let currencies = settingsController.getAvailableCurrencies()
    let items = currencies.map { currency in
      let title = NSMutableAttributedString()
      
      let code = "\(currency.code) ".withTextStyle(
        .label1,
        color: .Text.primary,
        alignment: .left,
        lineBreakMode: .byTruncatingTail
      )
      
      let name = currency.title.withTextStyle(
        .label1,
        color: .Text.secondary,
        alignment: .left,
        lineBreakMode: .byTruncatingTail
      )
      
      title.append(code)
      title.append(name)
      
      return SettingsCell.Model(
        identifier: currency.title,
        isSelectable: true,
        selectionHandler: { [weak self] in
          self?.settingsController.setCurrency(currency)
        },
        cellContentModel: SettingsCellContentView.Model(
          title: title
        )
      )
    }
    return SettingsListSection(items: items)
  }
}