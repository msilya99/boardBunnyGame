//
//  Array + Ex.swift
//  Zaec
//
//  Created by Ilya Maslau on 2.03.22.
//

extension Array {
    /// return single element of array, if this element exist
    var single: Element? {
        self.count == 1 ? self.first : nil
    }
}

extension Set {
    /// return single element of array, if this element exist
    var single: Element? {
        self.count == 1 ? self.first : nil
    }
}

