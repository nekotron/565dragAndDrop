//
//  dropView.swift
//  565dragAndDrop
//
//  Created by ジャスティン on 09/28/25.
//

import Foundation
import AppKit

class DropView: NSView {

    public var fileUrlObtained: (([URL]) -> Void)?
    
    var helpLabel : NSTextField!
    
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
        
        //In lieu of a help document display instructive label
        helpLabel = NSTextField(labelWithString: "Drag and drop images here\nto convert. Or, use File>Open")
        helpLabel.frame = NSRect(x: self.bounds.midX, y:self.bounds.midY, width: 200, height: 40)
        self.addSubview(helpLabel)
        
        // So we can still resize the window
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        // Set constraints equal to top right
        NSLayoutConstraint.activate([helpLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 80), helpLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70)])
    }

    // NSDraggingDestination

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
                print("path \(url.path)")
            }
            
            if let unwrappedFileUrlObtained = fileUrlObtained{
                unwrappedFileUrlObtained(fileURLs)
            }
            else {
                let alert = NSAlert()
                alert.messageText = "Callback function not set"
                alert.informativeText = "The callback function for handlng dropped urls has not been properly set. Try restarting the program. Please inform program author."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "OK")
                alert.runModal()
                return false
            }
            return true
        }
        return false
    }
}

