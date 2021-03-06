//
//  LoadFeedLoader.swift
//  FeedFetcher
//
//  Created by Nick Shi on 4/3/19.
//  Copyright © 2019 Nick Shi. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func cache(_ feeds: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feeds.toLocal(), timestamp: currentDate()) { [weak self] (error) in
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    public func save(_ feeds: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed {[weak self] (error) in
            guard let self = self else { return }
            
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feeds, completion: completion)
            }
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    public func load(completion: @escaping (LoadFeedResult) -> Void) {
        store.retrieve { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error) :
                completion(.failure(error))
                
            case let .found(feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))
                
            case .found, .empty: break
            }
            
        }
    }
    
    
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve {[weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
                
            case let .found(_, timestamp) where !self.validate(timestamp):
                self.store.deleteCachedFeed { _ in }
                
            case .empty, .found: break
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}



