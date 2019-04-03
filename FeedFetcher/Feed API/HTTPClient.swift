//
//  HTTPClient.swift
//  FeedFetcher
//
//  Created by Nick Shi on 4/3/19.
//  Copyright © 2019 Nick Shi. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
