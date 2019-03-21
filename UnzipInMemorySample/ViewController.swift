//
//  ViewController.swift
//  UnzipInMemorySample
//
//  Created by KS on 2019/01/22.
//  Copyright © 2019 KS. All rights reserved.
//

import UIKit
import ZIPFoundation

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var archive: Archive?
    var entries = [Entry]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "Archive", withExtension: "zip") else {
            return
        }
        
        archive = Archive(url: url, accessMode: .read)
        
        guard let archive = archive else {
            return
        }
        
        let iterator = archive.makeIterator()
        
        entries = iterator.map { $0 }
        
        if entries.isEmpty {
            return
        }
        
        do {
            try archive.extract(entries.first!, consumer: { data in
                imageView.image = UIImage(data: data)
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        let newIndex = index - 1
        guard 0 <= newIndex else {
            return
        }
        index = newIndex
        do {
            try archive?.extract(entries[index], consumer: { data in
                imageView.image = UIImage(data: data)
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        let newIndex = index + 1
        guard newIndex < entries.count else {
            return
        }
        index = newIndex
        do {
            try archive?.extract(entries[index], consumer: { data in
                imageView.image = UIImage(data: data)
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
