//
//  CurrentValueAsycSequence.swift
//  BikeTrack
//
//  Created by Mark Renaud on 30/8/2023.
//

import Foundation

/**
 A `AsyncSequence` based replacement for `CurrentValueSubject` publisher from the
 `Combine` framework.
 */
public final class CurrentValueAsyncSequence<T>: AsyncSequence where T: Sendable {
    public typealias Element = T
    
    private var currentValue: T
    /// current 'subscribers' listening for new values in the sequence
    private var listeners: [(T) -> Void] = []
    
    public init(_ initialValue: T) {
        self.currentValue = initialValue
    }
    
    public func makeAsyncIterator() -> AsyncStream<T>.Iterator {
        let x = AsyncStream<T> { [weak self] continuation in
            guard let self else { return }
            // Subscribe to changes
            self.listeners.append { newValue in
                continuation.yield(newValue)
            }
            
            // Send the initial value
            continuation.yield(self.currentValue)
            
        }.makeAsyncIterator()
        return x
    }
    
    /// updates the current value and sends to listeners watching
    /// for changes in the sequence
    public func send(_ newValue: T) {
        currentValue = newValue
        for listener in listeners {
            listener(newValue)
        }
    }
    
    /// A convenience to observe changes in the currentValue via a Task that executes
    /// the passed in closure on the Main
    public func observeOnMain(onChange: @escaping (_ newValue: T) -> ()) -> Task<Void, Never> {
        return Task {
            for await newValue in self {
                await MainActor.run {
                    onChange(newValue)
                }
            }
        }
    }
}
