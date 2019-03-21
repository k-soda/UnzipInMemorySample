//
//  ViewController.swift
//  UnzipInMemorySample
//
//  Created by KS on 2019/01/22.
//  Copyright © 2019 KS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "Archive", withExtension: "zip") else {
            return
        }
        
        ZipManager.shared.read(url: url) { data in
            self.imageView.image = UIImage(data: data)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        ZipManager.shared.goBack { data in
            self.imageView.image = UIImage(data: data)
        }
        
        backButton.isEnabled = ZipManager.shared.canGoBack()
        nextButton.isEnabled = ZipManager.shared.canGoNext()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        ZipManager.shared.goNext { data in
            self.imageView.image = UIImage(data: data)
        }
        
        backButton.isEnabled = ZipManager.shared.canGoBack()
        nextButton.isEnabled = ZipManager.shared.canGoNext()
    }
}
