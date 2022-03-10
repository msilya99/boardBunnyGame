//
//  SavingToFileHelper.swift
//  Zaec
//
//  Created by Ilya Maslau on 10.03.22.
//

import Foundation

class TopicsFileManagerHelper {

    //MARK: - variables

    private let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private var localPath: URL {
        return self.directoryURL.appendingPathComponent("topicsModel.txt")
    }

    // MARK: - actions

    func saveModelToFile(model: FirebaseTopicsModel) {
        guard let encodedData = try? JSONEncoder().encode(model) else { return }
        DispatchQueue.global(qos: .background).async(execute: {
            try? encodedData.write(to: self.localPath)
        })
    }

    func getModelFromFile() -> FirebaseTopicsModel? {
        guard let data = FileManager.default.contents(atPath: self.localPath.path) else { return nil }
        return try? JSONDecoder().decode(FirebaseTopicsModel.self, from: data)
    }
}
