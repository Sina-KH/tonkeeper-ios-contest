import UIKit
import TKUIKit

final class TokenPickerViewController: GenericViewViewController<TokenPickerView>, TKBottomSheetScrollContentViewController {
  typealias Item = TokenPickerCell.Model
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
  
  enum Section {
    case tokens
  }
  
  // Collection
  
  private lazy var dataSource = createDataSource()
  
  private let viewModel: TokenPickerViewModel
  
  init(viewModel: TokenPickerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupBindings()
    viewModel.viewDidLoad()
  }
  
  // MARK: - TKPullCardScrollableContent
  
  var scrollView: UIScrollView {
    customView.collectionView
  }
  var didUpdateHeight: (() -> Void)?
  var didUpdatePullCardHeaderItem: ((TKPullCardHeaderItem) -> Void)?
  var headerItem: TKUIKit.TKPullCardHeaderItem? {
    TKUIKit.TKPullCardHeaderItem(title: "Tokens")
  }
  func calculateHeight(withWidth width: CGFloat) -> CGFloat {
    scrollView.contentSize.height
  }
}

private extension TokenPickerViewController {
  func setup() {
    customView.collectionView.delegate = self
    customView.collectionView.register(
      TokenPickerCell.self,
      forCellWithReuseIdentifier: TokenPickerCell.reuseIdentifier
    )
    
    setupCollectionLayout()
  }
  
  func setupBindings() {
    viewModel.didUpdateTokens = { [weak self] tokens in
      self?.updateTokenItems(tokens)
    }
    
    viewModel.didUpdateSelectedToken = { [weak self] index in
      self?.customView.collectionView.selectItem(
        at: IndexPath(item: index, section: 0),
        animated: false,
        scrollPosition: .centeredVertically
      )
    }
  }
  
  func setupCollectionLayout() {
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .vertical
    
    let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(76)
        )
      )
      
      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(76)),
        subitems: [item]
      )

      let sectionLayout = NSCollectionLayoutSection(group: group)
      sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
      
      return sectionLayout
    }, configuration: configuration)
    
    customView.collectionView.setCollectionViewLayout(layout, animated: false)
  }
  
  func createDataSource() -> DataSource {
    DataSource(collectionView: customView.collectionView) { collectionView, indexPath, itemIdentifier in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TokenPickerCell.reuseIdentifier,
        for: indexPath
      ) as? TokenPickerCell
      cell?.configure(model: itemIdentifier)
      cell?.isFirstInSection = { return $0.item == 0 }
      cell?.isLastInSection = { [unowned collectionView] in
        let numberOfItems = collectionView.numberOfItems(inSection: $0.section)
        return $0.item == numberOfItems - 1
      }
      return cell
    }
  }
  
  func updateTokenItems(_ tokenItems: [TokenPickerCell.Model]) {
    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([.tokens])
    snapshot.appendItems(tokenItems, toSection: .tokens)
    snapshot.reloadItems(tokenItems)
    dataSource.apply(snapshot)
    didUpdateHeight?()
  }
}

extension TokenPickerViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItemAt(index: indexPath.item)
  }
}
