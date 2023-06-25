import Foundation

/// A set of values with an associated weight. The weight is used to influence getting random values
/// from the set.
struct WeightedSet<Value: Hashable> {
    typealias Storage = [Value: UInt]
    typealias Index = Storage.Index
    typealias Element = (value: Value, weight: UInt)
    
    private(set) var totalWeight: UInt = 0
    private var weightsByValue: Storage = [:]
    
    func randomValue() -> Value? {
        var generator = SystemRandomNumberGenerator()
        return randomValue(using: &generator)
    }
    
    func randomValue(using generator: inout some RandomNumberGenerator) -> Value? {
        guard totalWeight != 0 else { return nil }
        
        var remaining = generator.next(upperBound: totalWeight)
        
        for (value, weight) in weightsByValue.sorted(by: { $0.value > $1.value }) {
            guard remaining >= weight else {
                return value
            }
            
            remaining -= weight
        }
        
        fatalError("totalWeight had an incorrect value")
    }
    
    mutating func insert(_ newValue: Value, weight: UInt) {
        if let oldWeight = weightsByValue[newValue] {
            totalWeight -= oldWeight
        }
        
        totalWeight += weight
        weightsByValue[newValue] = weight
    }
    
    @discardableResult mutating func remove(_ value: Value) -> Element? {
        guard let weight = weightsByValue.removeValue(forKey: value) else {
            return nil
        }
        
        totalWeight -= weight
        return (value, weight)
    }
}
