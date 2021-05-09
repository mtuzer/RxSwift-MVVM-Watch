//
//  ObjectViewController.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import UIKit
import RxSwift
import RxCocoa
import WatchConnectivity

class ObjectViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var topView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.7)
        label.textColor = .white
        label.text = "   Artwork"
        label.font = .italicSystemFont(ofSize: 30)
        return label
    }()
    
    let objectCellId = "objectCellId"
        
    let subject = BehaviorSubject<[Object]>(value: [])
    
    let disposeBag = DisposeBag()
    
    var images = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp
                                .topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
                
        collectionView.register(ObjectCell.self, forCellWithReuseIdentifier: objectCellId)
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.top)
        }
        
        view.bringSubviewToFront(topView)
        LoadingAnimationView.shared.show()
        
        bindViewModel(viewModel: ViewModel())
    }

    func bindViewModel(viewModel: ViewModel) {
        // query for objects
        viewModel.input.country.onNext("Ottoman")
        
        // get query object IDs
        viewModel.output.objectIds.asObservable().subscribe(onNext: { objects in
            let uniqueElements = Array(Set(objects)).shuffled().prefix(6)
            let selectedOnes = Array(uniqueElements)
            viewModel.input.selectedObjectIds.onNext(selectedOnes)
        }).disposed(by: disposeBag)
            
        // get query objects and construct collection view with these objects
        viewModel.output.allObjects.asObservable()
            .do( onNext: { [weak self] objects in
                self?.sendParameters(objects: objects)
                LoadingAnimationView.shared.hide()
            })
            .bind(to: collectionView.rx.items(cellIdentifier: objectCellId, cellType: ObjectCell.self)) { _, obj, cell in
                cell.nameLabel.text = obj.name
                cell.mediumLabel.text = obj.medium
                cell.yearLabel.text = "\(obj.year ?? 1999)"
                cell.imageView.loadImageFromURLString(urlString: obj.image ?? "")
            }.disposed(by: disposeBag)
        
    }
    
    func sendParameters(objects: [Object]) {
        if WatchManager.shared.isWatchPaired() {
            let names = objects.map( { $0.name ?? "" })
            let imageURLs = objects.map( { $0.image ?? "" })
            let years = objects.map( { "\($0.year ?? 1999)" })
            WatchManager.shared.sendParametersToWatch(params: ["names": names,
                                                               "imageURLs": imageURLs,
                                                               "years": years])
        }
    }
}

extension ObjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        .init(top: 60, left: 0, bottom: 0, right: 0)
    }
}
