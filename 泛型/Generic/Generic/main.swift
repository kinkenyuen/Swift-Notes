//
//  main.swift
//  Generic
//
//  Created by kinken on 2021/12/11.
//

import Foundation

//func swapTwoInts(_ a: inout Int, _ b: inout Int) {
//    let temp = a
//    a = b
//    b = temp
//}

// MARK: 泛型基本

// 泛型函数
//func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
//    let temp = a
//    a = b
//    b = temp
//}

// 泛型类型
//struct Stack<Element> {
//    var items: [Element] = []
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }
//}

// MARK: 泛型扩展
// 为Stack<Element>添加一个计算属性
//extension Stack {
//    var topItem: Element? {
//        return items.isEmpty ? nil : items[items.count - 1]
//    }
//}

// MARK: 类型约束

// 非泛型函数
//func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
//    for (index, value) in array.enumerated() {
//        if value == valueToFind {
//            return index
//        }
//    }
//    return nil
//}

// 泛型版本
// 因为==操作符的原因，需要为泛型T加上遵循Equatable协议这个约束
//func findIndex<T : Equatable>(of valueToFine: T, in array:[T]) -> Int? {
//    for (index, value) in array.enumerated() {
//        if value == valueToFine {
//            return index
//        }
//    }
//    return nil
//}

// MARK: 关联类型
/*
 定义协议时，使用关联类型作为协议的一部分
 其代表的实际类型在协议被遵循时才会被指定
 关联类型使用associatedtype关键字指定
 */

// MARK: 关联类型实践
// 容器类协议
//protocol Container {
//    associatedtype Item
//    mutating func append(_ item: Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}

//struct Stack<Element> : Container {
//    // Stack<Element> 原始实现部分
//    var items: [Element] = []
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }
//
//    // Container 协议的实现部分
//    mutating func append(_ item: Element) {
//        self.push(item)
//    }
//
//    var count: Int {
//        return items.count
//    }
//
//    subscript(i: Int) -> Element {
//        return items[i]
//    }
//}

// MARK: 扩展现有类型来指定关联类型

//extension Array : Container {}

// MARK: 给关联类型添加约束
// 要求关联类型Item必须遵循Equatable协议
//protocol Container {
//    associatedtype Item : Equatable
//    mutating func append(_ item : Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}

// MARK: 在关联类型约束里使用协议
/*
 协议可以作为它自身的要求出现
 例如，有一个协议细化了Container协议，添加了一个suffix(_:)方法
 该方法返回容器中从后往前给定数量的元素，并把它们存储在一个Suffix类型的实例里
*/

//protocol Container {
//    associatedtype Item
//    mutating func append(_ item: Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}

//protocol SuffixableContainer : Container {
//    associatedtype Suffix : SuffixableContainer where Suffix.Item == Item
//    func suffix(_ size: Int) -> Suffix
//}

//struct Stack<Element : Equatable> : Container {
//    // Stack<Element> 原始实现部分
//    var items: [Element] = []
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }

//    // Container 协议的实现部分
//    mutating func append(_ item: Element) {
//        self.push(item)
//    }
//
//    var count: Int {
//        return items.count
//    }
//
//    subscript(i: Int) -> Element {
//        return items[i]
//    }
//}

//extension Stack : SuffixableContainer {
//    func suffix(_ size: Int) -> Stack {
//        var result = Stack()
//        for index in (count - size)..<count {
//            result.append(self[index])
//        }
//        return result
//    }
//    // 推断 suffix 结果是Stack
//}

//var stackOfInts = Stack<Int>()
//stackOfInts.append(10)
//stackOfInts.append(20)
//stackOfInts.append(30)
//print(stackOfInts.suffix(2))

// MARK: 泛型Where语句
/*
 通过泛型where子句让关联类型遵循某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同
 */

//protocol Container {
//    associatedtype Item
//    mutating func append(_ item: Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}

// C1的Item类型必须和C2的Item类型相同
//func allItemsMatch<C1: Container, C2: Container>
//(_ someContainer: C1, _ anotherContainer: C2) -> Bool
//where C1.Item == C2.Item, C1.Item : Equatable {
//    if someContainer.count != anotherContainer.count {
//        return false
//    }
//
//    for i in 0..<someContainer.count {
//        if someContainer[i] != anotherContainer[i] {
//            return false
//        }
//    }
//
//    return true
//}

// MARK: 具有泛型Where子句的扩展

//struct Stack<Element> {
//    var items: [Element] = []
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }
//}

// 要求栈的元素遵循Equatable协议才能使用isTop(_:)方法
//extension Stack where Element : Equatable {
//    func isTop(_ item: Element) -> Bool {
//        guard let topItem = items.last else { return false }
//        return topItem == item
//    }
//}

// MARK: 包含上下文关系的where分句

//protocol Container {
//    associatedtype Item
//    mutating func append(_ item: Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}
//
//extension Container {
//    func average() -> Double where Item == Int {
//        var sum = 0.0
//        for index in 0..<count {
//            sum += Double(self[index])
//        }
//        return sum / Double(count)
//    }
//
//    func endsWith(_ item: Item) -> Bool where Item: Equatable {
//        return count >= 1 && self[count - 1] == item
//    }
//}
//
//extension Array : Container {}
//
//let numbers = [1260, 1200, 98, 37]
//print(numbers.average())
//// 输出 "648.75"
//print(numbers.endsWith(37))
//// 输出 "true"
