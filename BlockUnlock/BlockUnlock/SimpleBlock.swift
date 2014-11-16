enum ConnectorType {
    case and, or, xor, blank
    
    static let opOrder = [xor, and, or]
}

class Connector : NSObject {
    var type : ConnectorType
    
    init(t:ConnectorType) {
        type = t
    }
    
    func isBlank() -> Bool {
        return isType(ConnectorType.blank)
    }
    func isType(t:ConnectorType) -> Bool {
        return type == t
    }
}

class SimpleBlock {
    var booleans : [NSNumber]
    var connectors : [Connector]
    
    init(difficulty:Int)  {
        booleans = [NSNumber]()
        connectors = [Connector]()
    }
    
    func evaluate() -> Bool? {
        switch evaluateRecursive(0, end:booleans.count) {
            case 0: return false
            case 1: return true
            case 2: return nil
            default: return nil
        }
    }
    
    func evaluateRecursive(start:Int, end:Int) -> Int {
        if (start == end) {
            return booleans[start]
        }
        
        var currentOpType : Int = 0
        var acted : Bool = false
        
        while currentOpType < ConnectorType.opOrder.count {
            for (index, op) in enumerate(connectors) {
                if (!op.isBlank() && op.isType(ConnectorType.opOrder[currentOpType])) {
                    let result = operate(op, a:evaluateRecursive(start, end:index), b:evaluateRecursive(index+1, end:end))
                    if (result != 2) { // look for all reasonable interpretations
                        return result
                    }
                }
            }
            currentOpType++;
        }
        
        return 2
    }
    
    func operate(c:Connector, a:Int, b:Int) -> Int {
        // see three-valued logic for guide
        switch c.type {
            case ConnectorType.and:
                if (a == 0 || b == 0) {
                    return 0
                } else if (a == 2 || b == 2) {
                    return 2
                } else {
                    return 1
                }
            case ConnectorType.or:
                if (a == 1 || b == 1) {
                    return 1
                } else if (a == 2 || b == 2) {
                    return 2
                } else {
                    return 0
                }
            case ConnectorType.xor:
                if (a == 2 || b == 2) {
                    return 2
                } else if (a != b ) {
                    return 1
                } else {
                    return 0
                }
            default: return 2
        }
    }
}
