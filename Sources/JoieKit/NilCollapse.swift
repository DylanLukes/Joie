//
//  NilCollapse.swift
//
//  Created by Dylan Lukes on 7/19/18.
//
//  No Rights Reserved.

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

infix operator ¿

func ¿<A1, R>(_ f: @escaping (A1) -> R, _ args: (A1?)) -> R? {
    guard let a1 = args else { return nil }
    return f(a1)
}

func ¿<A1, A2, R>(_ f: @escaping (A1, A2) -> R, _ args: (A1?, A2?)) -> R? {
    guard let a1 = args.0 else { return nil }
    guard let a2 = args.1 else { return nil }
    return f(a1, a2)
}

//func ¿<A1, A2, A3, R>(_ f: @escaping (A1, A2, A3) -> R) -> (A1?, A2?, A3?) -> R? {
//    return { (a1: A1?, a2: A2?, a3: A3?) -> R? in
//        guard let a1 = a1 else { return nil }
//        guard let a2 = a2 else { return nil }
//        guard let a3 = a3 else { return nil }
//        return f(a1, a2, a3)
//    }
//}
//
//func ¿<A1, A2, A3, A4, R>(_ f: @escaping (A1, A2, A3, A4) -> R) -> (A1?, A2?, A3?, A4?) -> R? {
//    return { (a1: A1?, a2: A2?, a3: A3?, a4: A4?) -> R? in
//        guard let a1 = a1 else { return nil }
//        guard let a2 = a2 else { return nil }
//        guard let a3 = a3 else { return nil }
//        guard let a4 = a4 else { return nil }
//        return f(a1, a2, a3, a4)
//    }
//}
//
//func ¿<A1, A2, A3, A4, A5, R>(_ f: @escaping (A1, A2, A3, A4, A5) -> R) -> (A1?, A2?, A3?, A4?, A5?) -> R? {
//    return { (a1: A1?, a2: A2?, a3: A3?, a4: A4?, a5: A5?) -> R? in
//        guard let a1 = a1 else { return nil }
//        guard let a2 = a2 else { return nil }
//        guard let a3 = a3 else { return nil }
//        guard let a4 = a4 else { return nil }
//        guard let a5 = a5 else { return nil }
//        return f(a1, a2, a3, a4, a5)
//    }
//}
//
//func ¿<A1, A2, A3, A4, A5, A6, R>(_ f: @escaping (A1, A2, A3, A4, A5, A6) -> R) -> (A1?, A2?, A3?, A4?, A5?, A6?) -> R? {
//    return { (a1: A1?, a2: A2?, a3: A3?, a4: A4?, a5: A5?, a6: A6?) -> R? in
//        guard let a1 = a1 else { return nil }
//        guard let a2 = a2 else { return nil }
//        guard let a3 = a3 else { return nil }
//        guard let a4 = a4 else { return nil }
//        guard let a5 = a5 else { return nil }
//        guard let a6 = a6 else { return nil }
//        return f(a1, a2, a3, a4, a5, a6)
//    }
//}
//
//func ¿<A1, A2, A3, A4, A5, A6, A7, R>(_ f: @escaping (A1, A2, A3, A4, A5, A6, A7) -> R) -> (A1?, A2?, A3?, A4?, A5?, A6?, A7?) -> R? {
//    return { (a1: A1?, a2: A2?, a3: A3?, a4: A4?, a5: A5?, a6: A6?, a7: A7?) -> R? in
//        guard let a1 = a1 else { return nil }
//        guard let a2 = a2 else { return nil }
//        guard let a3 = a3 else { return nil }
//        guard let a4 = a4 else { return nil }
//        guard let a5 = a5 else { return nil }
//        guard let a6 = a6 else { return nil }
//        guard let a7 = a7 else { return nil }
//        return f(a1, a2, a3, a4, a5, a6, a7)
//    }
//}
