//
//  PostCollectionViewCell.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/22/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var doubleTapLikeImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.imageView.center
        imageView.image = R.image.heart()
        imageView.tintColor = UIColor.white.withAlphaComponent(0.8)
        imageView.alpha = 0
        return imageView
    }()
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLikeGestureRecognizer()
        setupLikeImageView()
    }
    
    func setup(with post: String) {}

    // MARK: - Actions
    @IBAction fileprivate func likeButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    }
    
    @objc
    fileprivate func handleDoubleTapOnImage() {
        UIView.animate(withDuration: 0.4, animations: {
            self.doubleTapLikeImageView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                self.doubleTapLikeImageView.alpha = 0
            }
        }
    }
}

// MARK: - Configure UI
extension PostCollectionViewCell {
    fileprivate func setupLikeGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnImage))
        tapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupLikeImageView() {
        contentView.addSubview(doubleTapLikeImageView)
    }
}
