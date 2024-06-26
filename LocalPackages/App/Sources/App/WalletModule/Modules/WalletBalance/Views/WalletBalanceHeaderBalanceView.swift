import UIKit
import TKUIKit
import SnapKit

final class WalletBalanceHeaderBalanceView: UIView, ConfigurableView {
  
  private let balanceLabel = UILabel()
  private let statusView = ConnectionStatusView()
  private let addressButton = TKButton()
  private let tagView = TKUITagView()
  private let stateDateLabel = UILabel()
  
  private let stackView = UIStackView()
  private let addressTagContainer = UIStackView()
  private let addressTagStatusContainer = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  struct Model {
    let balance: String
    let addressButtonConfiguration: TKButton.Configuration
    let connectionStatusModel: ConnectionStatusView.Model?
    let tagConfiguration: TKUITagView.Configuration?
    let stateDate: String?
  }
  
  func configure(model: Model) {
    balanceLabel.attributedText = model.balance.withTextStyle(.balance, color: .Text.primary, alignment: .center)
    addressButton.configuration = model.addressButtonConfiguration
    stateDateLabel.attributedText = model.stateDate?.withTextStyle(.body2, color: .Text.secondary, alignment: .center)
    
    if let tagConfiguration = model.tagConfiguration {
      tagView.configure(configuration: tagConfiguration)
    }
    
    if let connectionStatusModel = model.connectionStatusModel {
      statusView.configure(model: connectionStatusModel)
    }
    
    addressTagContainer.isHidden = model.connectionStatusModel != nil || model.stateDate != nil
    statusView.isHidden = model.connectionStatusModel == nil
    tagView.isHidden = model.tagConfiguration == nil
    stateDateLabel.isHidden = model.stateDate == nil || model.connectionStatusModel != nil
  }
}

private extension WalletBalanceHeaderBalanceView {
  func setup() {
    stackView.axis = .vertical
    
    addressTagStatusContainer.axis = .vertical
    addressTagStatusContainer.alignment = .center
    addressTagStatusContainer.isLayoutMarginsRelativeArrangement = true
    addressTagStatusContainer.directionalLayoutMargins = .addressTagContainerPadding
    
    addressTagContainer.axis = .horizontal
    addressTagContainer.alignment = .center
    
    addSubview(stackView)
    stackView.addArrangedSubview(balanceLabel)
    stackView.addArrangedSubview(addressTagStatusContainer)
    addressTagContainer.addArrangedSubview(addressButton)
    addressTagContainer.addArrangedSubview(tagView)
    addressTagStatusContainer.addArrangedSubview(addressTagContainer)
    addressTagStatusContainer.addArrangedSubview(statusView)
    addressTagStatusContainer.addArrangedSubview(stateDateLabel)

    setupConstraints()
  }
  
  func setupConstraints() {
    balanceLabel.snp.makeConstraints { make in
      make.height.equalTo(CGFloat.balanceLabelHeight)
    }
    
    stackView.snp.makeConstraints { make in
      make.edges.equalTo(self).inset(UIEdgeInsets.stackViewPadding)
    }
  }
}

private extension CGFloat {
  static let balanceLabelHeight: CGFloat = 56
  static let addressTagStatusHeight: CGFloat = 32
}

private extension UIEdgeInsets {
  static var stackViewPadding = UIEdgeInsets(top: 28, left: 16, bottom: 16, right: 16)
  
}

private extension NSDirectionalEdgeInsets {
  static var addressTagContainerPadding = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0)
}
