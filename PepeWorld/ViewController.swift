//
//  ViewController.swift
//  PepeWorld
//
//  Created by 정재성 on 1/22/26.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class ViewController: UIViewController {
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: makeCollectionViewLayout()
  )

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Pepe World"

    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    Task {
      do {
        let images = try await ImageLoader().images()
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageLoader.ImageItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(images, toSection: 0)
        await dataSource.apply(snapshot)
      } catch {
        print(error)
      }
    }
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let imageItem = dataSource.itemIdentifier(for: indexPath) else { return }
    let detailViewController = ImageDetailViewController(imageItem: imageItem)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

extension ViewController {
  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, environment in
      let contentSize = environment.container.effectiveContentSize

      let size = (contentSize.width - 50) * 0.5
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(size)
        ),
        repeatingSubitem: NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .absolute(size),
            heightDimension: .absolute(size)
          )
        ),
        count: 2
      ).then {
        $0.interItemSpacing = .fixed(10)
        $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
      }

      return NSCollectionLayoutSection(group: group).then {
        $0.interGroupSpacing = 10
        $0.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
      }
    }
  }

  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ImageLoader.ImageItem> {
    let cellRegistration = UICollectionView.CellRegistration<ImageCell, ImageLoader.ImageItem> { cell, indexPath, image in
      cell.configure(with: image)
    }
    return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
  }
}

extension ViewController {
  final class ImageCell: UICollectionViewCell {
    let imageView = UIImageView().then {
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 8
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      contentView.addSubview(imageView)
      imageView.snp.makeConstraints {
        $0.directionalEdges.equalToSuperview()
      }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: ImageLoader.ImageItem) {
      imageView.kf.setImage(with: image.thumbnail)
    }
  }
}

private final class ImageDetailViewController: UIViewController {
  private let imageItem: ImageLoader.ImageItem

  private let scrollView = UIScrollView().then {
    $0.minimumZoomScale = 1
    $0.maximumZoomScale = 4
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
  }

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  init(imageItem: ImageLoader.ImageItem) {
    self.imageItem = imageItem
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = imageItem.title

    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.delegate = self

    scrollView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }

    imageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
      $0.width.equalTo(scrollView.snp.width)
      $0.height.equalTo(scrollView.snp.height)
    }

    imageView.kf.setImage(with: imageItem.image)
  }
}

extension ImageDetailViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
}

#Preview {
  UINavigationController(rootViewController: ViewController()).then {
    $0.navigationBar.prefersLargeTitles = true
  }
}
