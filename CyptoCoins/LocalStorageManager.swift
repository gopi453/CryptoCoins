//
//  LocalStorageManager.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit
protocol LocalStorable: AnyObject {
    func writeData(_ data: Encodable, for fileName: String, with fileExtension: String)
    func readData<T: Decodable>(for fileName: String, decodeType: T.Type) -> T?
}

final class LocalStorageManager: LocalStorable {

    func writeData(_ data: Encodable, for fileName: String, with fileExtension: String = "json") {
        do {
            let fileURL = try Utility.getFileURL(for: .fileName(fileName, fileExtension))
            try JSONEncoder()
                .encode(data)
                .write(to: fileURL)
        } catch {
            print("error writing data")
        }
    }
    
    func readData<T: Decodable>(for fileName: String, decodeType: T.Type) -> T? {
        do {
            let fileURL = try Utility.getFileURL(for: fileName)
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode(decodeType, from: data)
            return pastData
        } catch {
            return nil
        }
    }

}
