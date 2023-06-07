//
//  DefaultCellContentView.swift
//  Tonkeeper
//
//  Created by Grigory on 7.6.23..
//

import UIKit

final class DefaultCellContentView: UIView, ConfigurableView, ContainerCollectionViewCellContent {
  
  let textContentView = DefaultCellTextContentView()
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var textContentFrame: CGRect {
    .init(origin: .init(x: bounds.origin.x + .imageViewSide + .imageViewTextSpace,
                        y: bounds.minY),
          size: .init(width: bounds.width - .imageViewSide - .imageViewTextSpace,
                      height: bounds.height))
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let textContentSize = textContentView.sizeThatFits(.init(width: textContentFrame.width, height: 0))
    
    textContentView.frame.origin.x = textContentFrame.minX
    textContentView.frame.origin.y = bounds.height / 2 - textContentSize.height/2
    textContentView.frame.size = textContentSize
    
    imageView.frame.size = .init(width: .imageViewSide, height: .imageViewSide)
    imageView.frame.origin.x = 0
    imageView.center.y = textContentView.center.y
    
    imageView.layer.cornerRadius = .imageViewSide/2
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let textContentWidth = size.width - .imageViewSide - .imageViewTextSpace
    let textContentHeight = textContentView.sizeThatFits(.init(width: textContentWidth, height: 0)).height
    return .init(width: size.width, height: textContentHeight)
  }
  
  func configure(model: Model) {
    textContentView.configure(model: model.textContentModel)
    imageView.image = model.image
    setNeedsLayout()
  }
  
  func prepareForReuse() {
    imageView.image = nil
    textContentView.prepareForReuse()
  }
}

private extension DefaultCellContentView {
  func setup() {
    backgroundColor = .Background.content
    
    imageView.contentMode = .center
    
    addSubview(imageView)
    addSubview(textContentView)
    
    imageView.backgroundColor = .Accent.blue
  }
}

private extension CGFloat {
  static let imageViewSide: CGFloat = 44
  static let imageViewTextSpace: CGFloat = 16
}
