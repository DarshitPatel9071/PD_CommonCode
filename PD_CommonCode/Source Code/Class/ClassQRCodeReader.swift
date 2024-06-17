import AVFoundation
import UIKit
import CoreImage

protocol ClassQRCodeReader {
    func startReading(completion: @escaping (String,AVMetadataObject?) -> Void)
    func startReading(image:UIImage, completion: @escaping (String,AVMetadataObject?) -> Void)
    func stopReading()
    var  videoPreview: CALayer {get}
}


class AVCodeReader: NSObject {
    fileprivate(set) var videoPreview = CALayer()

    fileprivate var captureSession: AVCaptureSession?
    fileprivate var didRead: ((String,AVMetadataObject?) -> Void)?

    override init() {
        super.init()
        //Make sure the device can handle video
        guard let videoDevice = AVCaptureDevice.default(for: .video),let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}

        captureSession = AVCaptureSession()
        captureSession?.addInput(deviceInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr,.ean8, .ean13, .pdf417, .aztec, .upce, .code39, .code39Mod43, .code93, .code128]

        //preview
        guard let captureSession = captureSession else { return }
        let captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoPreview.videoGravity = .resizeAspectFill
        self.videoPreview = captureVideoPreview
    }
}

extension AVCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let code = readableCode.stringValue else { return }
        //Vibrate the phone
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopReading()
        didRead?(code,readableCode)
    }
}

extension AVCodeReader: ClassQRCodeReader {
  
    func startReading(completion: @escaping (String,AVMetadataObject?) -> Void) {
        self.didRead = completion
        captureSession?.startRunning()
    }
    func startReading(image: UIImage, completion: @escaping (String,AVMetadataObject?) -> Void) {
        let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage:CIImage=CIImage(image:image)!
        var qrCodeLink=""
        let features=detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopReading()
        completion(qrCodeLink, nil)
    }
    func stopReading() {
        captureSession?.stopRunning()
    }
    
   
}
