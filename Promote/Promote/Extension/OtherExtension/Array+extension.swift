//
//  Array+extension.swift
//  Promote
//
//  Created by Bavaria on 29/03/2018.
//



extension Array {
    subscript(safe index: Int) -> Element? {
        //        debugPrint("111", indices)
        //        return indices ~= index ? self[index] : nil
        return indices.contains(index) ? self[index] : nil
    }
}

