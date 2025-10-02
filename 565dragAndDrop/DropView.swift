//
//  dropView.swift
//  565dragAndDrop
//
//  Created by ジャスティン on 09/28/25.
//

import Foundation
import AppKit

class DropView: NSView {

    
    //public var fileUrlObtained: (([NSURL]) -> Void)?
    public var fileUrlObtained: (([URL]) -> Void)?
    
    override init(frame rect: NSRect){
        super.init(frame: rect)
        
        awakeFromNib()
    }
    
    required init?(coder coderIn: NSCoder){
        super.init(coder: coderIn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([.fileURL]) // Register for file URLs as drop types
        NSLog("awake from nib")
    }

    // MARK: - NSDraggingDestination

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Determine if the dragged items are acceptable
        if sender.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: nil) {
            return .copy // Indicate a copy operation
        }
        return []
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let fileURLs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            for url in fileURLs {
                // Handle the dropped file, e.g., move or copy it
                //print("Dropped file: \(url.lastPathComponent)")
                //print("Dropped file: \(url.absoluteString)")
                //print("standardizedFileURL \(url.standardizedFileURL)")
                //print("pathExtension \(url.pathExtension)")
                print("path \(url.path)")
            }
            fileUrlObtained!(fileURLs)
            return true
        }
        return false
    }
}

