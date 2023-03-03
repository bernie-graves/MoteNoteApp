//
//  FunFactFetcher.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/12/23.
//

import Foundation
import SwiftUI
import Combine

class FunFactFetcher: ObservableObject {
    @Published var fact: String?

    private let userDefaults = UserDefaults.standard
    private let key = "FunFact"

    init() {
        fact = userDefaults.string(forKey: key)
    }

    func fetchFact() {
        let lastFetched = userDefaults.double(forKey: "LastFetched")
        let now = Date().timeIntervalSince1970

        if lastFetched == 0 || now - lastFetched >= 86400 { // 86400 seconds in a day
            let url = URL(string: "https://api.adviceslip.com/advice")!

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoded = try! JSONDecoder().decode(Advice.self, from: data)
                    DispatchQueue.main.async {
                        self.fact = decoded.slip.advice
                        self.userDefaults.set(decoded.slip.advice, forKey: self.key)
                        self.userDefaults.set(now, forKey: "LastFetched")
                    }
                }
            }
            .resume()
        }
    }
}

struct Advice: Decodable {
    let slip: Slip
}

struct Slip: Decodable {
    let advice: String
}

