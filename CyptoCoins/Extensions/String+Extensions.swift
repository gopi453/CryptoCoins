//
//  String+Extensions.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import Foundation
extension String {
    static func fileName(_ fileName: String,_ ext: String) -> String {
        return "\(fileName).\(ext)"
    }
}
