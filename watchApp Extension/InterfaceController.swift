//
//  InterfaceController.swift
//  watchApp Extension
//
//  Created by Mert Tuzer on 8.05.2021.
//

import WatchKit
import Foundation
import Network

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var objectTable: WKInterfaceTable!
    let monitor = NWPathMonitor()
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        let name = NSNotification.Name.init(rawValue: "DataReceived")
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
            name: name, object: nil
        )
        
        checkForInternetConnection() // only for controlling the connection
    }
    
    @objc func dataDidFlow(_ notification: Notification) {
        guard let data = notification.object as? [String: Any] else {
            return
        }
                
        if let names = data["names"] as? [String],
           let imageURLs = data["imageURLs"] as? [String],
           let years = data["years"] as? [String] {
            
            objectTable.setNumberOfRows(names.count, withRowType: "ObjectRow")
            
            for index in 0..<names.count {
                guard let row = objectTable.rowController(at: index) as? ObjectRow else {
                    return
                }
                
                row.imageView.setImageWithUrl(url: imageURLs[index])
                row.yearLabel.setText(years[index])
                row.nameLabel.setText(names[index])
            }
        }

    }
    
    fileprivate func checkForInternetConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected!")
            } else {
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
}
