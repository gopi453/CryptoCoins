//
//  Utility.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit

struct Utility {

    static let appThemeColor: UIColor = .init(red: 86 / 255, green: 12 / 255, blue: 225 / 255, alpha: 1)

    static func fetchLocalArrayData<T: Decodable>(from store: LocalStorable = LocalStorageManager(), for fileName: String, with fileExtension: String = "json", decodeType: [T].Type) -> [T]? {
        guard let data = store.readData(for: .fileName(fileName, fileExtension), decodeType: decodeType), !data.isEmpty else {
            return nil
        }
        return data
    }

    static func getSelectedFilters() -> [CoinsFilterCollectionData] {
        let filterViewModel = CoinsFilterViewModel()
        return filterViewModel.filtersData.filter({ $0.isSelected == true })
    }

    static func getFileURL(for fileName: String) throws -> URL {
        let fileURL = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
        return fileURL
    }

    static func checkFileExists(for fileName: String, with fileExtension: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(.fileName(fileName, fileExtension)) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: filePath)
        } else {
            return false
        }
    }

}
