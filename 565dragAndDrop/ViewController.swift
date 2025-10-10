//
//  ViewController.swift
//  565dragAndDrop
//
//  Created by ジャスティン on 09/27/25.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var directoryTextField: NSTextField!
    @IBOutlet weak var ppmPreviewButton: NSButton!
    @IBOutlet weak var invertColorButton: NSButton!
    @IBOutlet weak var interpolateButton: NSButton!
    @IBOutlet weak var enableDebugButton: NSButton!
    
    
    var imgConverter = ImageConvert()
    var myDropView: DropView!
    var files = [NSURL]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        NotificationCenter.default.addObserver(self, selector: #selector(openFileDialog), name: Notification.Name("OpenClicked"), object: nil)
        myDropView = DropView(frame: NSRect(x: 0, y: 0, width: self.view.bounds.maxX, height: self.view.bounds.maxY))
        myDropView.fileUrlObtained = self.filesDropped
        self.view.addSubview(myDropView)
        
         
        // Necessary when using Auto Layout programmatically
        myDropView.translatesAutoresizingMaskIntoConstraints = false
          
        // Set the constraints to take up the whole window so dropping the file anywhere will always work no matter how the window is resized
        NSLayoutConstraint.activate([myDropView.topAnchor.constraint(equalTo: self.view.topAnchor), myDropView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor), myDropView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), myDropView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
        
    }

    //We have to call this to change the window.title
    //Doing this in viewDidLoad results in the window being titled "Window"
    override func viewDidAppear() {
        super.viewDidAppear()
        if let window = self.view.window {
            window.title = "RGB565 Drag and Drop"
        }
    }
    
    //This was for an earlier version that had a test button. This will be removed in a future commit.
    /*
    @IBAction func runTestPushed(_ sender: Any) {
        let hght = heightTextField.intValue
        let wdth = widthTextField.intValue
        let drct = directoryTextField.stringValue
        let doesPPM = (ppmPreviewButton.intValue != 0)
        let doesNeg = (invertColorButton.intValue != 0)
        let doesInt = (interpolateButton.intValue != 0)
        let doesDbg = (enableDebugButton.intValue != 0)
        var doesDir = false
        
        var isDirectory : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: drct, isDirectory: &isDirectory)
        
        if(exists && isDirectory.boolValue){
            NSLog("Directory \(drct) exists")
        }
        else {
            NSLog("Directory \(drct) does not exist")
        }
        
        doesDir = (exists && isDirectory.boolValue)
        
        NSLog("hght %d", hght)
        NSLog("wdth %d", wdth)
        NSLog("drct %@", drct)
        NSLog("doesPPM = %d", doesPPM)
        NSLog("doesNeg = %d", doesNeg)
        NSLog("doesInt = %d", doesInt)
        NSLog("DoesDbg = %d", doesDbg)
        NSLog("doesDir = %d", doesDir)
        
        imgConverter.parseOptions(hght, withWidth: wdth, hasDirectory: doesDir, withDirectory: drct, hasDebugOn: doesDbg, hasInterpolation: doesInt, hasNegative: doesNeg, hasPpmPreview: doesPPM)
        imgConverter.imageConverter(1, arguments: ["</USE/LOCAL/PATH/FOR/TESTING.png>"])
    }
    */
    
    //function that will be called from function "pointer" in DropView that will handle the fileUrls for processing.
    func filesDropped(fileUrls: [URL]){
        let hght = heightTextField.intValue
        var drct = directoryTextField.stringValue
        let wdth = widthTextField.intValue
        let doesPPM = (ppmPreviewButton.intValue != 0)
        let doesNeg = (invertColorButton.intValue != 0)
        let doesInt = (interpolateButton.intValue != 0)
        let doesDbg = (enableDebugButton.intValue != 0)
        var doesDir = false
        
        var isDirectory : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: drct, isDirectory: &isDirectory)
        
        if (doesDbg){
            if(exists && isDirectory.boolValue){
                NSLog("\n\nDirectory \(drct) exists")
            }
            else {
                NSLog("\n\nDirectory \(drct) does not exist")
            }
            if (drct == "") {
                NSLog("Path Empty")
                if (!exists){
                    NSLog("Path empty and doesn't exist")
                }
            }
        }
        
        
        if (drct != "" && !exists) {
            NSLog("Not a valid path")
            let alert = NSAlert()
            alert.messageText = "Invalid path"
            alert.informativeText = "Invalid path entered. Please check spelling. Click continue to use input image directory as output directory."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "Continue")
            alert.addButton(withTitle: "Abort")
            let response = alert.runModal()
            
            switch response {
            case NSApplication.ModalResponse.alertFirstButtonReturn:
                print("Continuing")
            case NSApplication.ModalResponse.alertSecondButtonReturn:
                print("Aborting")
                return;
            default:
                break
            }
        
        
        }
        
        doesDir = (exists && isDirectory.boolValue)
        if (!doesDir) {
            drct = ""
        }
        
        if (doesDbg){
            NSLog("hght %d", hght)
            NSLog("wdth %d", wdth)
            NSLog("drct %@", drct)
            NSLog("doesPPM = %d", doesPPM)
            NSLog("doesNeg = %d", doesNeg)
            NSLog("doesInt = %d", doesInt)
            NSLog("DoesDbg = %d", doesDbg)
            NSLog("doesDir = %d", doesDir)
        }
        
        imgConverter.parseOptions(hght, withWidth: wdth, hasDirectory: doesDir, withDirectory: drct, hasDebugOn: doesDbg, hasInterpolation: doesInt, hasNegative: doesNeg, hasPpmPreview: doesPPM)
        for url in fileUrls {
            let outUrl = url.path
            imgConverter.imageConverter(1, arguments: [outUrl])
        
        }

    }
    
    @objc func openFileDialog(){
        var outUrls = [URL]()
        
        let panel = NSOpenPanel()

        // Configure the panel
        panel.title = "Choose image files"
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = ["jpg", "png", "jpeg"]

        // Present the panel as a sheet attached to the current window
        panel.beginSheetModal(for: self.view.window!) { (response) in
            if response == .OK {
                for selectedUrl in panel.urls {
                    print("Selected file: \(selectedUrl.path)")
                    outUrls.append(selectedUrl)
                }
                self.filesDropped(fileUrls: outUrls)
            }
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

