//
//  FeedLoader.swift
//  FeedFetcher
//
//  Created by Nick Shi on 4/3/19.
//  Copyright © 2019 Nick Shi. All rights reserved.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}


public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
