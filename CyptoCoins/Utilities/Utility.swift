//
//  Utility.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit

struct Utility {

    static let appThemeColor: UIColor = .init(red: 86 / 255, green: 12 / 255, blue: 225 / 255, alpha: 1)

    static func checkFileExists(for fileName: FileName, with fileType: FileType = .json) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(.fileName(fileName.description, fileType.rawValue)) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: filePath)
        } else {
            return false
        }
    }

}
