//
//  CatCell.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import UIKit
import SnapKit

class ObjectCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var mediumLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .red
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.backgroundColor = .black.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9).priority(999)
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.05).priority(999)
//            make.top.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(300)
        }
        
        containerView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(mediumLabel)
        mediumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40).priority(999)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
