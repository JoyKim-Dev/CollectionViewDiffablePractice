//
//  ViewController.swift
//  CollectionViewDiffablePractice
//
//  Created by Joy Kim on 7/19/24.
//

import UIKit
import SnapKit

struct SettingOptions: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}


class SettingViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
        case personal
        case others
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    var dataSource: UICollectionViewDiffableDataSource<Section, SettingOptions>!
    
    let list = [
        [SettingOptions(title: "공지사항", subtitle: "공지사항페이지"),
         SettingOptions(title: "실험실", subtitle: "실험실페이지"),
         SettingOptions(title: "버전정보", subtitle: "버전정보페이지")],
        [SettingOptions(title: "개인/보안", subtitle: "개인/보안페이지"),
         SettingOptions(title: "알림", subtitle: "알림페이지"),
         SettingOptions(title: "채팅", subtitle: "채팅페이지"),
         SettingOptions(title: "멀티프로필", subtitle: "멀티프로필페이지")],
        [SettingOptions(title: "고객센터", subtitle: "고객센터페이지"),
         SettingOptions(title: "도움말", subtitle: "도움말페이지")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "설정"
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSouce()
        updateSnapshot()
    }
    
    func layout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
        configuration.backgroundColor = .white
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    func configureDataSouce() {
        
        
        let registration: UICollectionView.CellRegistration<UICollectionViewListCell, SettingOptions>!
        registration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
            content.textProperties.color = .darkGray
            
            content.secondaryText = itemIdentifier.subtitle
            content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .semibold)
            content.secondaryTextProperties.color = .systemPink
            
            content.imageProperties.tintColor = .orange
            content.image = UIImage(systemName: "heart.fill")
            
            cell.contentConfiguration = content
            
            var backgroudConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroudConfig.backgroundColor = .yellow.withAlphaComponent(0.2)
            cell.backgroundConfiguration = backgroudConfig
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SettingOptions>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list[0], toSection: .main)
        snapshot.appendItems(list[1], toSection: .personal)
        snapshot.appendItems(list[2], toSection: .others)
        
        dataSource.apply(snapshot)
    }
    
    
    
    
}

