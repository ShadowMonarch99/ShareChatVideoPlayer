//
//  VideoPlayerViewModel.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 22/03/26.
//

import AVKit

final class VideoPlayerViewModel: ObservableObject {
    
    @Published var player: AVPlayer?
    
    var videos: [Video]
    @Published var currentIndex: Int
    
    init(videos: [Video], currentIndex: Int) {
        self.videos = videos
        self.currentIndex = currentIndex
        setupPlayer()
    }
    
    func setupPlayer() {
        guard videos.indices.contains(currentIndex),
              let url = URL(string: videos[currentIndex].videoFiles?.first?.link ?? "")
        else { return }
        
        player = AVPlayer(url: url)
        player?.play()
        
        observeEnd()
    }
    
    func playNext() {
        currentIndex += 1
        
        if currentIndex >= videos.count {
            currentIndex = 0
        }
        
        setupPlayer()
    }
    
    private func observeEnd() {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.playNext()
        }
    }
}
