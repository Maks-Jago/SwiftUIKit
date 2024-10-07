//===--- VideoPlayer.swift ---------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import SwiftUI
import AVKit

/// A SwiftUI wrapper for `AVPlayerViewController` to play videos using a specified URL path.
public struct VideoPlayerView: UIViewControllerRepresentable {
    public var videoUrlPath: String
    
    /// Creates a `VideoPlayerView`.
    /// - Parameter videoUrlPath: The URL path of the video to play.
    public init(videoUrlPath: String) {
        self.videoUrlPath = videoUrlPath
    }
    
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        if let videoURL = URL(string: videoUrlPath) {
            let player = AVPlayer(url: videoURL)
            controller.player = player
            controller.player?.play()
        }
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
#endif
