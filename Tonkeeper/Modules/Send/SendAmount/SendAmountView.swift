//
//  SendAmountSendAmountView.swift
//  Tonkeeper

//  Tonkeeper
//  Created by Grigory Serebryanyy on 31/05/2023.
//

import UIKit

final class SendAmountView: UIView {
  
  let continueButton: TKButton = {
    let button = TKButton(configuration: .primaryLarge)
    button.titleLabel.text = "Continue"
    return button
  }()
  
  lazy var continueButtonActivityContainer: ActivityViewContainer = {
    .init(view: continueButton)
  }()

  private let contentView = UIView()
  private let enterAmountContainer = UIView()
  
  private var contentViewBottomConstraint: NSLayoutConstraint?
  
  private var keyboardHeight: CGFloat = 0
  
  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    updateContentViewBottomConstraint()
  }
  
  // MARK: - Embed
  
  func embedEnterAmountView(_ enterAmountView: UIView) {
    enterAmountContainer.addSubview(enterAmountView)
    enterAmountView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      enterAmountView.topAnchor.constraint(equalTo: enterAmountContainer.topAnchor),
      enterAmountView.leftAnchor.constraint(equalTo: enterAmountContainer.leftAnchor),
      enterAmountView.rightAnchor.constraint(equalTo: enterAmountContainer.rightAnchor)
        .withPriority(.defaultHigh),
      enterAmountView.bottomAnchor.constraint(equalTo: enterAmountContainer.bottomAnchor)
        .withPriority(.defaultHigh)
    ])
  }
  
  // MARK: - Keyboard
  
  func updateKeyboardHeight(_ height: CGFloat,
                            duration: TimeInterval,
                            curve: UIView.AnimationCurve) {
    keyboardHeight = height
    updateContentViewBottomConstraint()
    layoutIfNeeded()
    UIViewPropertyAnimator(duration: duration, curve: curve) {
      self.layoutIfNeeded()
    }
    .startAnimation()
  }
}

// MARK: - Private

private extension SendAmountView {
  func setup() {
    backgroundColor = .Background.page
    
    addSubview(contentView)
    contentView.addSubview(enterAmountContainer)
    contentView.addSubview(continueButtonActivityContainer)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    enterAmountContainer.translatesAutoresizingMaskIntoConstraints = false
    continueButtonActivityContainer.translatesAutoresizingMaskIntoConstraints = false
    
    contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    contentViewBottomConstraint?.isActive = true
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: ContentInsets.sideSpace),
      contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -ContentInsets.sideSpace)
        .withPriority(.defaultHigh),
      
      enterAmountContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      enterAmountContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      enterAmountContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        .withPriority(.defaultHigh),
      
      continueButtonActivityContainer.topAnchor.constraint(equalTo: enterAmountContainer.bottomAnchor),
      continueButtonActivityContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      continueButtonActivityContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      continueButtonActivityContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
  
  func updateContentViewBottomConstraint() {
    contentViewBottomConstraint?.constant = keyboardHeight == 0
    ? -safeAreaInsets.bottom
    : -(keyboardHeight + .contentViewBottomSpace)
  }
}

private extension CGFloat {
  static let contentViewBottomSpace: CGFloat = 16
}
