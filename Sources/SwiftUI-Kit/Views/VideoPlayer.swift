//
//  VideoPlayer.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI
import AVKit

public struct VideoPlayerView: UIViewControllerRepresentable {
    public var videoUrlPath: String
    
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
