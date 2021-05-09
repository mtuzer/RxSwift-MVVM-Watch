//
//  SplashViewController.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        infoLabel.text = "Let's have a splash screen to load content..."
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(view.snp.centerY).offset(120)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // it is a fake loading process
            LoadingAnimationView.shared.hide()
            AppDelegate.shared.rootViewController.showMainScreen()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LoadingAnimationView.shared.show()
    }
}
