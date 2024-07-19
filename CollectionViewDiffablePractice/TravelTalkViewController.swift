//
//  TravelTalkViewController.swift
//  CollectionViewDiffablePractice
//
//  Created by Joy Kim on 7/19/24.
//

import UIKit
import SnapKit

class TravelTalkViewController: UIViewController {
    
    enum Section:CaseIterable {
        case all
    }

    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "친구 이름을 검색해보세요"
        return searchBar
    }()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Chat>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Travel Talk"
        configureDataSouce()
        updateSnapshot()
        configHierarchy()
        configLayout()
    
    }
    
    func configHierarchy(){
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    func configLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .white
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    func configureDataSouce() {
        
        let registration: UICollectionView.CellRegistration<UICollectionViewListCell, Chat>!
        registration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = itemIdentifier.user.rawValue
            content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
            content.textProperties.color = .darkGray
            
            content.secondaryText = itemIdentifier.message
            content.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .semibold)
            content.secondaryTextProperties.color = .systemPink
            
            content.textToSecondaryTextVerticalPadding = 10
            
            let label = UILabel()
            let date = DateFormatterManager.dateToString(date: itemIdentifier.date)
            label.text = date
            label.textColor = .gray
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            
            let customLabel = UICellAccessory.CustomViewConfiguration(customView: label, placement: .trailing(displayed: .always))
          
            let containerView = UIView()
            containerView.frame.size = .init(width: 40, height: 40)
            containerView.layer.cornerRadius = 20
            let profile = UIImageView()
            containerView.addSubview(profile)
            profile.frame = containerView.bounds
            
//            content.imageProperties.maximumSize = .init(width: 60, height: 60)
//            content.imageProperties.cornerRadius = 30
            profile.image = UIImage(named: "\(itemIdentifier.user.profileImage)")
            profile.contentMode = .scaleAspectFill
            
            let customProfile = UICellAccessory.CustomViewConfiguration(customView: profile, placement: .leading(displayed: .always), reservedLayoutWidth:  .actual, maintainsFixedSize: true)
            
            cell.accessories = [.customView(configuration: customLabel), .customView(configuration: customProfile)]
            cell.contentConfiguration = content
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Chat>()
        snapshot.appendSections(Section.allCases)
        for i in ChatList.mockChatList {
            if let lastChat = i.chatList.last {
                snapshot.appendItems([lastChat], toSection: .all)
            }
            dataSource.apply(snapshot)
        }
    }
}

