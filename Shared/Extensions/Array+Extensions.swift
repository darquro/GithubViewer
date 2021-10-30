//
//  Array+Extensions.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import Foundation

extension Array where Element: Hashable {

    func unique() -> Array {
        var hash = [Element : Bool]()
        return reduce([], { (array, element) in
            if hash[element] != nil { return array }
            hash[element] = true
            return array + [element]
        })
    }
}
