//
//  VIdeoListModelUnitTests.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 22/03/26.
//

import XCTest
@testable import ShareChatVideoPlayer

@MainActor
final class VideoListViewModelTests: XCTestCase {
    
    var mockService: MockVideoService!
    var viewModel: VideoListViewModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockVideoService()
        viewModel = VideoListViewModel(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_fetchVideos_success_updatesVideos() async {
        mockService.videos = mockService.mockVideos
        
        await viewModel.fetchVideos()
        
        XCTAssertEqual(viewModel.videos.count, 3)
        XCTAssertEqual(mockService.fetchCallCount, 1)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_fetchVideos_failure_setsError() async {
        mockService.shouldFail = true
        
        await viewModel.fetchVideos()
        
        XCTAssertTrue(viewModel.videos.isEmpty)
        XCTAssertEqual(viewModel.error, "Failed to load videos")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_fetchVideos_doesNotCallAPI_multipleTimes() async {
        mockService.videos = mockService.mockVideos
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.viewModel.fetchVideos() }
            group.addTask { await self.viewModel.fetchVideos() }
        }
        
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }
    
    func test_loadMoreIfNeeded_triggersFetch_forLastItem() async {
        mockService.videos = mockService.mockVideos
        
        await viewModel.fetchVideos()
        
        let lastVideo = viewModel.videos.last!
        
        await viewModel.loadMoreIfNeeded(current: lastVideo)
        
        XCTAssertEqual(mockService.fetchCallCount, 2)
    }
    
    func test_loadMoreIfNeeded_doesNotTriggerFetch_forNonLastItem() async {
        mockService.videos = mockService.mockVideos
        
        await viewModel.fetchVideos()
        
        let firstVideo = viewModel.videos.first!
        
        await viewModel.loadMoreIfNeeded(current: firstVideo)
        
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }
}
