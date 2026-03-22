//
//  MockService.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 22/03/26.
//

import SwiftUI

final class MockVideoService: VideoServiceProtocol {
    
    var shouldFail = false
    var videos: [Video] = []
    var fetchCallCount = 0
    
    func fetchVideos(page: Int) async throws -> VideoResponse? {
        fetchCallCount += 1
        
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        
        return VideoResponse(page: 1, perPage: 15, videos: videos.isEmpty ? mockVideos : videos)
    }
    
    let mockVideos: [Video] = [
        Video(id: 1, image: "Thumbnail1", duration: 10, user: User(name: "John Doe"), videoFiles: [VideoFile(link: "Video1", quality: "sd")]),
        Video(id: 2, image: "Thumbnail2", duration: 8, user: User(name: "Jane Smith"), videoFiles: [VideoFile(link: "Video1", quality: "sd")]),
        Video(id: 3, image: "Thumbnail3", duration: 12, user: User(name: "Alex Johnson"), videoFiles: [VideoFile(link: "Video1", quality: "sd")])]
}
