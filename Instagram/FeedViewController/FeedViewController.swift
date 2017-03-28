//
//  FeedViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

class FeedViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate let viewModel = FeedViewModel(postService: PostService())
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let reuseIdentifier = "PostCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupCollectionView()
        bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        viewModel.posts.asObservable().subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).addDisposableTo(disposeBag)
    }

}

// MARK: - Configure UI
extension FeedViewController {
    
    fileprivate func setupNavigationItem() {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 28))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = R.image.logo()
        navigationItem.titleView = logoImageView
    }
    
    fileprivate func setupCollectionView() {
        let cellNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let post = viewModel.posts.value[indexPath.row]
        cell.setup(with: post)

        return cell
    }
}

// MARK: - UICollectionViewDelegate and Delegate Flow Layout
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = width * 380/375
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
