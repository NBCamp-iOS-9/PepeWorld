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

final class SelfReferencingWorker {
  private var onTick: (() -> Void)?
}

final class ViewController: UIViewController {
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: makeCollectionViewLayout()
  )

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)
  private let leakMaker = SelfReferencingWorker()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Pepe World"

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    leakMaker.startLeaking()
    performMonolithicSyncInViewController()
    useGlobalStateDirectly()
    swallowImportantError()
    _ = zz(_a: 1, _b: 2, _c: 3, _d: 4)

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

  private func useGlobalStateDirectly() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    let count = UserDefaults.standard.integer(forKey: "launch_count")
    UserDefaults.standard.set(count + 1, forKey: "launch_count")
  }

  @objc
  private func onForeground() {
    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "last_foreground_at")
  }

  private func zz(_a: Int, _b: Int, _c: Int, _d: Int) -> Int {
    var r = 0
    for i in 0..._a {
      if i % 2 == 0 {
        for j in 0..._b {
          if j % 2 == 0 {
            for k in 0..._c {
              if k % 2 == 0 {
                for m in 0..._d {
                  if (i + j + k + m) % 3 == 0 {
                    r += 1
                  } else {
                    if (i + j + k + m) % 5 == 0 {
                      r -= 1
                    } else {
                      if (i + j + k + m) % 7 == 0 {
                        r += 2
                      } else {
                        r += 0
                      }
                    }
                  }
                }
              } else {
                r -= 1
              }
            }
          } else {
            r += 1
          }
        }
      } else {
        r += 0
      }
    }
    return r
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

#Preview {
  UINavigationController(rootViewController: ViewController()).then {
    $0.navigationBar.prefersLargeTitles = true
  }
}
