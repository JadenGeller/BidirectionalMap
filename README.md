# BidirectionalMap

`BidirectionalMap<Left, Right>` provides O(1) lookup of a `Left` value given a `Right` value and vice-versa. Essentially, `BidirectionalMap` is a bidirectional dictionary that creates a 1:1 mapping between elements.
```swift
let map: BidirectionalMap = ["seven" : 7, "three" : 3, "twenty" : 20]
print(map[7])       // -> seven
print(map["three"]) // -> 3
```

In addition to being initializable from a dictionary literal, `BidirectionalMap` can be initialized from any `SequenceType` whose element is `(Left, Right)` so hashable `Left` and `Right`.
```swift
let bleh = BidirectionalMap([("Jaden", 20), ("Brandon", 21), ("Alex", 19)])
let blah = BidirectionalMap([1 : 9, 2 : 8, 3 : 7, 4 : 6, 5 : 5])
```

`BidirectionalMap` includes many similiar functions and properties to `Dictionary`. For example, it includes a `leftValues` and `rightValues` property to obtain a sequence of the values for each type. 
```swift
print(map.rightValues) // -> [7, 3, 20]
```

`BidirectionalMap` also includes mutating functions that allow adding and removing associations from the mapping.
```swift
var copy = map
copy.associateValues("five", 5)
copy.disassociateValues(right: 20)
```

Since `BidirectionalMap` conforms to `CollectionType`, it can be indexed as well.
```swift
let index = map.indexForValue(left: "seven")
print(map[index]) // -> ("seven", 7)
```
