//
//  ZipManager.swift
//  UnzipInMemorySample
//
//  Created by KS on 2019/03/21.
//  Copyright © 2019 KS. All rights reserved.
//

import Foundation
import ZIPFoundation

final class ZipManager {
    
    enum Result {
        case success
        case failure
    }
    
    typealias Process = (Data) -> Void
    
    static let shared = ZipManager()
    
    private var archive: Archive?
    private var entries = [Entry]()
    private var index = 0
    
    @discardableResult
    func read(url: URL, process: Process? = nil) -> Result {
        archive = Archive(url: url, accessMode: .read)
        
        guard let archive = archive else {
            return .failure
        }
        
        let iterator = archive.makeIterator()
        
        entries = iterator.map { $0 }
        
        if entries.isEmpty {
            return .failure
        }
        
        return goTo(index: 0, process: process)
    }
    
    func canGoBack() -> Bool {
        guard 0 <= index - 1 else {
            return false
        }
        
        return true
    }
    
    func canGoNext() -> Bool {
        guard index + 1 < entries.count else {
            return false
        }
        
        return true
    }
    
    @discardableResult
    func goBack(process: Process? = nil) -> Result {
        guard canGoBack() else {
            return .failure
        }
        
        return goTo(index: index - 1, process: process)
    }
    
    @discardableResult
    func goNext(process: Process? = nil) -> Result {
        guard canGoNext() else {
            return .failure
        }
        
        return goTo(index: index + 1, process: process)
    }
    
    @discardableResult
    func goFirst(process: Process? = nil) -> Result {
        return goTo(index: 0, process: process)
    }
    
    @discardableResult
    func goLast(process: Process? = nil) -> Result {
        return goTo(index: entries.count - 1, process: process)
    }
}

private extension ZipManager {
    
    func goTo(index: Int, process: Process? = nil) -> Result {
        do {
            _ = try archive?.extract(entries[index], consumer: { data in
                process?(data)
                self.index = index
            })
        } catch {
            debugPrint(error.localizedDescription)
            return .failure
        }
        
        return .success
    }
}
