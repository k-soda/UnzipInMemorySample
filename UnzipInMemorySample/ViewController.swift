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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "Archive", withExtension: "zip") else {
            return
        }
        guard let archive = Archive(url: url, accessMode: .read) else {
            return
        }
        
        let iterator = archive.makeIterator()
        let entries = iterator.map { $0 }
        
        entries.forEach { entry in
            do {
                try archive.extract(entry, consumer: { data in
                    print(entry.path)
                })
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
