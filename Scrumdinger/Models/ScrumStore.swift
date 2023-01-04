//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Max Shu on 04.01.2023.
//

import Foundation
import SwiftUI

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false
        )
        .appendingPathComponent("scrums.data")
    }

    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // add a save method
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // encode the scrums data
                let data = try JSONEncoder().encode(scrums)
                // Create a constant for the file URL.
                let outfile = try fileURL()
                // Write the encoded data to the file.
                try data.write(to: outfile)
                // Pass the number of scrums to the completion handler.
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                // pass the error to the completion handler.
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

