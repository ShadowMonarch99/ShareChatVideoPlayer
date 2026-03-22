//
//  VideoListViewModel.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import Foundation

@MainActor
final class VideoListViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let service: VideoServiceProtocol
    private var currentPage = 1
    private var isFetching = false
    
    init(service: VideoServiceProtocol = VideoService()) {
        self.service = service
    }
    
    func fetchVideos() async {
        guard !isFetching else { return }
        
        isFetching = true
        isLoading = true
        error = nil
        
        do {
            let response = try await service.fetchVideos(page: currentPage)
            videos.append(contentsOf: response?.videos ?? [])
            currentPage += 1
        } catch {
            self.error = "Failed to load videos"
        }
        
        isLoading = false
        isFetching = false
    }
    
    func loadMoreIfNeeded(current video: Video) async {
        guard video == videos.last else { return }
        await fetchVideos()
    }
}
