//
//  main.swift
//  qrcode
//
//  Created by Marcus Schappi on 9/5/21.
//

import Foundation
import CoreImage
import Cocoa

func captureRegion(_ destination: URL) -> URL {
    let destinationPath = destination.path as String
    
    let task = Process()
    task.launchPath = "/usr/sbin/screencapture"
    task.arguments = ["-i", "-r", destinationPath]
    task.launch()
    task.waitUntilExit()
    
    return destination
}

func detectQRCode(fileName : URL) -> [CIFeature]? {
    if let ciImage = CIImage(contentsOf: fileName){
    let context = CIContext()
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
    let features = qrDetector?.features(in: ciImage, options: options)
    return features
}
    return nil
}

let args = CommandLine.arguments
var inputURL = URL(fileURLWithPath: "/tmp/qrcode.png")
if args.count > 1 {
    inputURL = URL(fileURLWithPath: args[1])
} else {
    let _ = captureRegion(inputURL)
}


if let features = detectQRCode(fileName : inputURL), !features.isEmpty{
    for case let row as CIQRCodeFeature in features{
        print(row.messageString ?? "nope")
    }
    
}

exit(EXIT_SUCCESS)
