//
//  ViewController.swift
//  VisionDemo1
//
//  Created by 李智揚 on 2017/9/5.
//  Copyright © 2017年 Yowoo Tech Inc. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let request = VNDetectFaceRectanglesRequest(completionHandler: detectFaceCompletion)
        let image = CIImage(image: imageView.image!)!
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        
        do {
            try handler.perform([request])
        } catch {}
    }
    
    func detectFaceCompletion(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            return
        }
        for observation in observations {
            let convertedRect = transformRect(fromRect: observation.boundingBox, toViewRect: self.imageView)
            let view = UIView(frame: convertedRect)
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 3
            view.backgroundColor = .clear
            self.imageView!.addSubview(view)
        }
    }
}

