import Foundation

struct PairsGenerator {
    typealias Item = String
    
    let history: [GeneratedPairs]
    let items: [Item]
    let randomizationWeighting: Config.RandomizationWeighting
        
    func next() -> GeneratedPairs {
        var remainingItems: [Item: WeightedSet<Item>] = [:]
        
        // Add default weights for every combination of items
        for item1 in items {
            for item2 in items
            where item1 != item2 {
                let weight = weight(for: items.count)
                remainingItems[item1, default: .init()].insert(item2, weight: weight)
                remainingItems[item2, default: .init()].insert(item1, weight: weight)
            }
        }
        
        // GeneratedPairs ordered from oldest to newest where the offset is the number of pairs
        // since this pairs were used.
        let orderedGeneratedPairs = history
            .sorted { $0.date > $1.date }
            .enumerated()
            .reversed()
        
        // Update weights to be the number of weeks since they last paired
        for (offset, generatedPairs) in orderedGeneratedPairs {
            for pair in generatedPairs.pairs
            where pair.participation == .yes {
                let item1 = pair.item1
                guard let item2 = pair.item2 else { continue }
                
                // If one of the items is not in the dictionary, it means they're not in `items`
                // and should not be added as a possible pair.
                guard remainingItems[item1] != nil,
                      remainingItems[item2] != nil
                else { continue }
                
                let weight = weight(for: offset)
                
                remainingItems[item1]?.insert(item2, weight: weight)
                remainingItems[item2]?.insert(item1, weight: weight)
            }
        }
        
        var generatedPairs = GeneratedPairs()
        
        // Pick an item with highest totalWeight to make a pair for
        while let item1 = remainingItems.max(by: \.value.totalWeight)?.key {
            // Pick another item at random
            let item2 = remainingItems[item1]?.randomValue()
            
            // Remove both items from remainingItems
            remainingItems.removeValue(forKey: item1)
            if let item2 {
                remainingItems.removeValue(forKey: item2)
            }
            
            // Remove both items from the remainingItems weighted sets
            for key in remainingItems.keys {
                remainingItems[key]?.remove(item1)
                if let item2 {
                    remainingItems[key]?.remove(item2)
                }
            }
            
            // Add the pair to the generated pairs
            generatedPairs.pairs.append(.init(item1: item1, item2: item2))
        }
        
        return generatedPairs
    }
    
    private func weight(for offset: Int) -> UInt {
        switch randomizationWeighting {
        case .exponential:
            return UInt(offset * offset)
        case .linear:
            return UInt(offset)
        case .uniform:
            return 1
        }
    }
}

private extension Collection {
    func max(by keyPath: KeyPath<Element, some Comparable>) -> Element? {
        self.max { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
