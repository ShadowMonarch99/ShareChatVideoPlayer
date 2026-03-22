//
//  VideoPlayerView.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    let videos: [Video]
    @State var currentIndex: Int
    
    @State private var player = AVPlayer()
    @State private var playerObserver: NSObjectProtocol?
    @State private var isMuted = false
        
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(spacing: 12) {
                playerSection
                queueHeader
                queueList
            }
            .onAppear { playVideo() }
            .onChange(of: currentIndex) { _ in playVideo() }
        }
    }
    
    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color.black,
                Color.black.opacity(0.85),
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var playerSection: some View {
        ZStack(alignment: .topTrailing) {
            
            VideoPlayer(player: player)
                .frame(height: 280)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 12)
            
            Button {
                isMuted.toggle()
                player.isMuted = isMuted
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(12)
        }
        .padding(.horizontal)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -50 {
                        playNext()
                    } else if value.translation.height > 50 {
                        playPrevious()
                    }
                }
        )
    }
        
    
    private var queueHeader: some View {
        VStack(spacing: 2) {
            Text("In Queue")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("\(videos.count) videos")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
    
    private var queueList: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(videos.indices, id: \.self) { index in
                    QueueRow(
                        video: videos[index],
                        index: index,
                        isActive: index == currentIndex
                    ) {
                        currentIndex = index
                    }
                }
            }
            .padding(.top, 6)
        }
    }
    
    struct QueueRow: View {
        let video: Video?
        let index: Int
        let isActive: Bool
        let onTap: () -> Void
        
        var body: some View {
            HStack(spacing: 12) {
                
                AsyncImage(url: URL(string: video?.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure(_):
                        ZStack {
                            Color.gray.opacity(0.3)
                            Image(systemName: "photo")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                        }
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 90, height: 60)
                .clipped()
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video?.user?.name ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Video \(index + 1)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isActive ? Color.blue.opacity(0.25) : Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.08))
            )
            .padding(.horizontal)
            .onTapGesture(perform: onTap)
        }
    }
    
    // MARK: - Play Video
    private func playVideo() {
        guard let videoUrl = URL(string: videos[currentIndex].videoFiles?.first?.link ?? "") else { return }
                
        let item = AVPlayerItem(url: videoUrl)
        player.replaceCurrentItem(with: item)
        player.isMuted = isMuted
        player.play()
        
        // Remove old observer
        if let observer = playerObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        // Auto play next
        playerObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            playNext()
        }
    }
        
    
    // MARK: - Next / Previous
    private func playNext() {
        guard currentIndex + 1 < videos.count else { return }
        currentIndex += 1
    }
    
    private func playPrevious() {
        guard currentIndex - 1 >= 0 else { return }
        currentIndex -= 1
    }
}
