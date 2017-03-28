//
//  SendPostViewController.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SendPostViewController: UIViewController {
    
    @IBOutlet fileprivate weak var selectedImageView: UIImageView!
    @IBOutlet fileprivate weak var captionTextView: UITextView!

    fileprivate let viewModel = SendPostViewModel(postService: PostService())
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        captionTextView.rx.text.bindTo(viewModel.caption).addDisposableTo(disposeBag)
    }

    @IBAction fileprivate func shareButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.sharePost()
    }

}
