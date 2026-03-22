//
//  VideoServiceProtocol.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import Foundation

protocol VideoServiceProtocol {
    func fetchVideos(page: Int) async throws -> VideoResponse?
}

final class VideoService: VideoServiceProtocol {
    
    func fetchVideos(page: Int) async throws -> VideoResponse? {
        let urlString = "https://api.pexels.com/videos/popular?page=\(page)&per_page=20"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(VideoResponse.self, from: data)
    }
}
