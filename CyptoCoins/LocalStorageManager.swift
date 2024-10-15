//
//  LocalStorageManager.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import UIKit
protocol LocalStorable: AnyObject {
    func writeData(_ data: Encodable, for fileName: String)
    func readData(for fileName: String) -> Encodable?
}

class LocalStorageManager: LocalStorable {

    private func getFileURL(for fileName: String) throws -> URL {
        let fileURL = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
        return fileURL
    }
    
    func writeData(_ data: Encodable, for fileName: String) {
        do {
            let fileURL = try getFileURL(for: fileName)
            try JSONEncoder()
                .encode(data)
                .write(to: fileURL)
        } catch {
            print("error writing data")
        }
    }
    
    func readData(for fileName: String) -> Encodable? {
        do {
            let fileURL = try getFileURL(for: fileName)
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode([CoinsFilterCollectionData].self, from: data)
            return pastData
        } catch {
            return nil
        }
    }

}
