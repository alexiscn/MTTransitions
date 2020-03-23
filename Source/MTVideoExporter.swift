//
//  MTVideoExporter.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/23.
//

import AVFoundation

typealias MTVideoExporterCompletion = (Error?) -> Void

public class MTVideoExporter {
    
    private let composition: AVMutableComposition
    
    private let videoComposition: AVMutableVideoComposition
    
    private var exportSession: AVAssetExportSession
    
    public init(composition: AVMutableComposition,
                videoComposition: AVMutableVideoComposition,
                presetName: String = AVAssetExportPresetMediumQuality) throws {
        self.composition = composition
        self.videoComposition = videoComposition
        guard let session = AVAssetExportSession(asset: composition, presetName: presetName) else {
            fatalError("Can not create AVAssetExportSession")
        }
        self.exportSession = session
        self.exportSession.videoComposition = videoComposition
    }
    
    private func export(to fileURL: URL, completion: @escaping MTVideoExporterCompletion) {
        
        let filePath = NSTemporaryDirectory().appending("ExportedProject.mp4")
        let fileExists = FileManager.default.fileExists(atPath: filePath)
        if fileExists {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print("An error occured deleting the file: \(error)")
            }
        }
        exportSession.outputURL = URL(fileURLWithPath: filePath)
        exportSession.outputFileType = AVFileType.mp4
        
        let startTime = CMTimeMake(value: 0, timescale: 1)
        let timeRange = CMTimeRangeMake(start: startTime, duration: composition.duration)
        exportSession.timeRange = timeRange
        
        exportSession.exportAsynchronously(completionHandler: {
            if let error = self.exportSession.error {
                print("Exported error:\(error)")
            } else {
                print("exported")
            }
        })
    }
    
}
