//
//  WebViewController.swift
//  QRScanner
//
//  Created by Rajendra on 05/10/18.
//  Copyright © 2018 Rajendra. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let stringUrl = UserDefaults.standard.string(forKey: "githubUrl") {
            print(stringUrl)
            
            //webview.load(URLRequest(url: URL(fileURLWithPath: stringUrl)))
            
            let url = URL(string: stringUrl)
            webview.load(URLRequest(url: url!))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
