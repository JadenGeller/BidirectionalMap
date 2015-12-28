//
//  BidirectionalMap.swift
//  BidirectionalMap
//
//  Created by Jaden Geller on 12/27/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/// A bidirectional mapping between values of different types. Provides O(1) lookup time for both
/// `Left -> Right` and `Right -> Left`.
public struct BidirectionalMap<Left: Hashable, Right: Hashable> {
    private var leftToRightMapping = [Left : Right]()
    private var rightToLeftMapping = [Right : Left]()
    
    /// Construct a bidirectional mapping from a sequence of tuples `(Left, Right)`.
    /// Fails if a unique mapping does not exist for each element.
    public init?<S: SequenceType where S.Generator.Element == (Left, Right)>(_ sequence: S) {
        for pair in sequence {
            let (a, b) = associateValues(pair)
            guard a == nil && b == nil else { return nil }
        }
    }
    
    /// Associates `left` with `right`, removing the previous associations of the values from the mapping and returning
    /// a tuple of these associations.
    public mutating func associateValues(left: Left, _ right: Right) -> (Right?, Left?) {
        return (leftToRightMapping.updateValue(right, forKey: left), rightToLeftMapping.updateValue(left, forKey: right))
    }
    
    /// Removes the association between `left` and its corresponding `Right` value, if it exists,
    /// and returns the `Right` value.
    public mutating func disassociateValues(left left: Left) -> Right? {
        guard let right = leftToRightMapping.removeValueForKey(left) else { return nil }
        rightToLeftMapping.removeValueForKey(right)
        return right
    }
    
    /// Removes the association between `right` and its corresponding `Left` value, if it exists,
    /// and returns the `Left` value.
    public mutating func disassociateValues(right right: Right) -> Left? {
        guard let left = rightToLeftMapping.removeValueForKey(right) else { return nil }
        leftToRightMapping.removeValueForKey(left)
        return left
    }
    
    /// Removes all associations.
    public mutating func disassociateAll(keepCapacity keepCapacity: Bool = false) {
        leftToRightMapping.removeAll(keepCapacity: keepCapacity)
        rightToLeftMapping.removeAll(keepCapacity: keepCapacity)
    }

    /// A collection containing just the `Left` values of self.
    public var leftValues: LazyMapCollection<Dictionary<Left, Right>, Left> {
        return leftToRightMapping.keys
    }
    
    /// A collection containing just the `Right` values of self.
    public var rightValues: LazyMapCollection<Dictionary<Left, Right>, Right> {
        return leftToRightMapping.values
    }
    
    /// Obtain the associated `Right` value given a `Left` value, or `nil` if the mapping doesn't exist.
    public func getAssociatedValue(left left: Left) -> Right? {
        return leftToRightMapping[left]
    }
    
    /// Obtain the associated `Left` value given a `Right` value, or `nil` if the mapping doesn't exist.
    public func getAssociatedValue(right right: Right) -> Left? {
        return rightToLeftMapping[right]
    }

    /// Obtain the associated `Right` value given a `Left` value, or `nil` if the mapping doesn't exist.
    public subscript(left: Left) -> Right? {
        return getAssociatedValue(left: left)
    }
    
    /// Obtain the associated `Left` value given a `Right` value, or `nil` if the mapping doesn't exist.
    public subscript(right: Right) -> Left? {
        return getAssociatedValue(right: right)
    }
}

extension BidirectionalMap: DictionaryLiteralConvertible {
    /// Construct a bidirectional mapping from a dictionary literal.
    public init(dictionaryLiteral elements: (Left, Right)...) {
        self.init(elements)!
    }
}

extension BidirectionalMap: CollectionType {
    public func generate() -> DictionaryGenerator<Left, Right> {
        return leftToRightMapping.generate()
    }
    
    public var startIndex: DictionaryIndex<Left, Right> {
        return leftToRightMapping.startIndex
    }
    
    public var endIndex: DictionaryIndex<Left, Right> {
        return leftToRightMapping.endIndex
    }
    
    public subscript(position: DictionaryIndex<Left, Right>) -> (Left, Right) {
        return leftToRightMapping[position]
    }
    
    /// Returns the `Index` for the given `Left` value, or nil if the value is not present in the dictionary.
    public func indexForValue(left left: Left) -> DictionaryIndex<Left, Right>? {
        return leftToRightMapping.indexForKey(left)
    }
    
    /// Returns the `Index` for the given `Right` value, or nil if the value is not present in the dictionary.
    public func indexForValue(right right: Right) -> DictionaryIndex<Left, Right>? {
        guard let left = getAssociatedValue(right: right) else { return nil }
        return indexForValue(left: left)
    }
    
    /// Removes the association between values at the given `index`, returning the removed pair.
    public mutating func disassociateAtIndex(index: DictionaryIndex<Left, Right>) -> (Left, Right) {
        let (left, right) = leftToRightMapping.removeAtIndex(index)
        rightToLeftMapping.removeValueForKey(right)
        return (left, right)
    }
    
    /// If `!self.isEmpty`, remove and return the first left-right pair, otherwise return nil.
    mutating func popFirst() -> (Left, Right)? {
        guard !isEmpty else { return nil }
        return disassociateAtIndex(startIndex)
    }
}

extension BidirectionalMap: CustomStringConvertible {
    public var description: String {
        return leftToRightMapping.description
    }
}
