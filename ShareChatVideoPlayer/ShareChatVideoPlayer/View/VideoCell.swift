//
//  VideoCell.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import SwiftUI

struct VideoCell: View {
    
    let video: Video
    @State private var isLoaded = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            AsyncImage(url: URL(string: video.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.3)) {
                                isLoaded = true
                            }
                        }
                    
                case .failure(_):
                    /// Fallback UI if image fails
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.7))
                    }
                case .empty:
                    /// Loading
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 140)
            .clipped()
            .cornerRadius(16)
            .scaleEffect(isLoaded ? 1 : 0.95)
            
            /// Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(16)
            
            /// Labels
            VStack(alignment: .leading, spacing: 2) {
                Text(video.user?.name ?? "")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if let duration = video.duration {
                    Text("\(duration)s")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(8)
        }
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}
