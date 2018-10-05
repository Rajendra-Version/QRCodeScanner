//
//  ViewController.swift
//  QRScanner
//
//  Created by Rajendra on 05/10/18.
//  Copyright © 2018 Rajendra. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    var timer = Timer()
    var avPlayer: AVPlayer!
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(playSound), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func playSound() {
        
        timer.invalidate()
        let path = Bundle.main.path(forResource: "audio_assist", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        avPlayer = AVPlayer(url: url)
        avPlayer.play()
    }
    
    @IBAction func scanButtonTapped(sender: UIButton!) {
        
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            
            let stringResult = result?.value

            if stringResult != nil {
                
                if stringResult!.range(of:"github.com") != nil {
                    print("exists")
                    UserDefaults.standard.set(stringResult, forKey: "githubUrl")
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        
        let stringResult = result.value
        
        if stringResult.range(of:"github.com") == nil {
            
            let alert = UIAlertController(title: "Message", message: "Invalid QR code", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

