//
//  Optional+Sequence.swift
//  Socket
//
//  Created by Dylan Lukes on 3/2/18.
//

extension Optional: IteratorProtocol, Sequence {
    public typealias Element = Wrapped
    
    public mutating func next() -> Optional<Wrapped> {
        defer { self = nil }
        return self
    }
    
    public func makeIterator() -> Optional {
        /// A copy serves as the iterator.
        return self
    }
}
