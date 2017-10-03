import AVFoundation
import Vision
import UIKit

class PixelBufferVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet private weak var cameraView: UIView?
    
    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard
            let backCamera = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession.addOutput(videoOutput)
        /// Set Orientation
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        // begin the session
        captureSession.startRunning()
        cameraLayer.videoGravity = AVLayerVideoGravity.resize
        cameraView?.layer.addSublayer(cameraLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraLayer.frame = self.cameraView?.bounds ?? .zero
    }
    
    var views = [UIView]()
    
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation]
            else { return }
        DispatchQueue.main.async {
            
            for view in self.views {
                view.removeFromSuperview()
            }
            self.views = []
            
            for observation in observations {
                let convertedRect = transformRect(fromRect: observation.boundingBox, toViewRect: self.cameraView!)
                let view = makeBorderView(frame: convertedRect)
                self.cameraView!.addSubview(view)
                self.views.append(view)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
                self.shouldFetch = true
            })
        }
        
        
    }
    
    var shouldFetch = true
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard
            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            shouldFetch
            else { return }
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let detectFaceRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
        } catch {
            print(error)
        }
        shouldFetch = false
    }
}


