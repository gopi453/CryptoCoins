//
//  LocalStorageManager.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit
enum FileName: CustomStringConvertible {
    case dashboard, coinsFilter, custom(String)
    var description: String {
        switch self {
        case .dashboard:
            return "dashboard"
        case .coinsFilter:
             return "coinsFilter"
        case .custom(let string):
            return string
        }
    }
}
enum FileType: String {
    case json, text = "txt", rich = "rtf"
}
protocol LocalStorable: AnyObject {
    func writeData<T: Encodable>(_ data: T, for fileName: FileName, with fileExtension: FileType)
    func readData<T: Decodable>(for fileName: FileName, fileExtension: FileType, decodeType: T.Type) -> T?
}

final class LocalStorageManager: LocalStorable {
    private let userDefaults: UserDefaults
    private let fileManager: FileManager
    private let directoryURL: URL
    
    init(userDefaults: UserDefaults = .standard, fileManager: FileManager = .default) {
        self.userDefaults = userDefaults
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func writeData<T: Encodable>(_ data: T, for fileName: FileName, with fileExtension: FileType = .json) {
        do {
            let url = directoryURL.appendingPathComponent(.fileName(fileName.description, fileExtension.rawValue))
            try JSONEncoder().encode(data).write(to: url)
        } catch {
            print("error writing data")
        }
    }
    
    func readData<T: Decodable>(for fileName: FileName, fileExtension: FileType = .json, decodeType: T.Type) -> T? {
        do {
            let url = directoryURL.appendingPathComponent(.fileName(fileName.description, fileExtension.rawValue))
            let data = try Data(contentsOf: url)
            let pastData = try JSONDecoder().decode(decodeType, from: data)
            return pastData
        } catch {
            return nil
        }
    }

}
