//
//  VideoListScreen.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import SwiftUI

struct VideoListView: View {
    
    @StateObject private var viewModel = VideoListViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // Background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        ///Custom Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("My Feed")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            
                            Text("Whats Trending?")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        /// Grid
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.videos) { video in
                                NavigationLink {
                                    VideoPlayerView(videos: viewModel.videos, currentIndex: index(of: video))
                                } label: {
                                    VideoCell(video: video)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.plain)
                                .scaleEffect(0.98)
                            }
                        }
                        .padding(.horizontal, 12)
                        
                        /// Loader
                        if viewModel.isLoading {
                            VStack(spacing: 10) {
                                ProgressView()
                                    .tint(.white)
                                
                                Text("Loading videos...")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.fetchVideos()
            }
        }
    }
    
    private func index(of video: Video) -> Int {
        viewModel.videos.firstIndex(of: video) ?? 0
    }
}
