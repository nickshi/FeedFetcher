//
//  RemoteFeedItem.swift
//  FeedFetcher
//
//  Created by Nick Shi on 4/3/19.
//  Copyright © 2019 Nick Shi. All rights reserved.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let locaiton: String?
    let image: URL
}
