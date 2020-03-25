//
//  MTVideoExporter.swift
//  MTTransitions
//
//  Created by xushuifeng on 2020/3/23.
//

import AVFoundation

public typealias MTVideoExporterCompletion = (Error?) -> Void

public class MTVideoExporter {
    
    private let composition: AVMutableComposition
    
    private let videoComposition: AVMutableVideoComposition
    
    private let exportSession: AVAssetExportSession
    
    public convenience init(transitionResult: MTVideoTransitionResult, presetName: String = AVAssetExportPresetHighestQuality) throws {
        try self.init(composition: transitionResult.composition, videoComposition: transitionResult.videoComposition, presetName: presetName)
    }
    
    public init(composition: AVMutableComposition,
                videoComposition: AVMutableVideoComposition,
                presetName: String = AVAssetExportPresetHighestQuality) throws {
        self.composition = composition
        self.videoComposition = videoComposition
        guard let session = AVAssetExportSession(asset: composition, presetName: presetName) else {
            fatalError("Can not create AVAssetExportSession, please check composition")
        }
        self.exportSession = session
        self.exportSession.videoComposition = videoComposition
    }
    
    /// Export the composition to local file.
    /// - Parameters:
    ///   - fileURL: The output fileURL.
    ///   - outputFileType: The output file type. `mp4` by default.
    ///   - completion: Export completion callback.
    public func export(to fileURL: URL, outputFileType: AVFileType = .mp4, completion: @escaping MTVideoExporterCompletion) {
        
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        if fileExists {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("An error occured deleting the file: \(error)")
            }
        }
        exportSession.outputURL = fileURL
        exportSession.outputFileType = outputFileType
        
        let startTime = CMTimeMake(value: 0, timescale: 1)
        let timeRange = CMTimeRangeMake(start: startTime, duration: composition.duration)
        exportSession.timeRange = timeRange
        
        exportSession.exportAsynchronously(completionHandler: { [weak self] in
            completion(self?.exportSession.error)
        })
    }
}
