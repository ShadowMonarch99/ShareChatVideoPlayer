# ShareChatVideoPlayer

A SwiftUI-based video browsing and playback app.

---

## Features

* Grid-based video feed with pagination
* Tap to play any video
* Auto-play next video on completion
* Swipe to navigate between videos
* Mute / unmute support
* Async thumbnail loading with fallback UI

---

## Architecture

Follows MVVM:

* VideoListView: Grid UI
* VideoPlayerView: Playback and queue
* VideoListViewModel: State and pagination
* VideoServiceProtocol: Networking

---

## Tech Stack

* SwiftUI
* AVKit
* Async/Await
* URLSession

---

## Key Concepts

* AVPlayer lifecycle management
* Pagination with duplicate request prevention
* Graceful handling of network failures
* Lightweight and responsive UI
