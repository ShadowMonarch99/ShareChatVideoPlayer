//
//  VideoResponseModel.swift
//  ShareChatVideoPlayer
//
//  Created by Apoorv Joshi on 21/03/26.
//

import Foundation

struct VideoResponse: Codable {
    let page: Int?
    let perPage: Int?
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case videos
    }
}

struct Video: Codable, Identifiable, Equatable {
    let id: Int?
    let image: String?
    let duration: Int?
    let user: User?
    let videoFiles: [VideoFile]?
    
    enum CodingKeys: String, CodingKey {
        case id, image, duration, user
        case videoFiles = "video_files"
    }
}

struct User: Codable, Equatable {
    let name: String?
}

struct VideoFile: Codable, Equatable {
    let link: String?
    let quality: String?
}
