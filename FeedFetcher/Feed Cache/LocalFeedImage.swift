//
//  LocalFeedImage.swift
//  FeedFetcher
//
//  Created by Nick Shi on 4/3/19.
//  Copyright © 2019 Nick Shi. All rights reserved.
//

import Foundation

public struct LocalFeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
