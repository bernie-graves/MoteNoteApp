//
//  AffirmationsFetcher.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/12/23.
//

import Foundation
import SwiftUI
import Combine

class AffirmationFetcher: ObservableObject {
    @Published var affirmation1: String?
    @Published var affirmation2: String?
    @Published var affirmation3: String?

    
    private let userDefaults = UserDefaults.standard
    private let key1 = "Affirmation1"
    private let key2 = "Affirmation2"
    private let key3 = "Affirmation3"

    init() {
        affirmation1 = userDefaults.string(forKey: key1)
        affirmation2 = userDefaults.string(forKey: key2)
        affirmation3 = userDefaults.string(forKey: key3)
    }


    func fetchAffirmation(num:Int) {
        let lastFetched = userDefaults.double(forKey: "LastFetchedAffirmation")
        let now = Date().timeIntervalSince1970
        
        if lastFetched == 0 || now - lastFetched >= 86400 {
            guard let url = URL(string: "https://www.affirmations.dev") else { return }
            let headers = ["Accept": "application/json"]
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                    
                }
                
                let affirmation = try? JSONDecoder().decode(Affirmation.self, from: data)
                DispatchQueue.main.async {
                    if num == 1 {
                        self.affirmation1 = affirmation!.affirmation
                        self.userDefaults.set(self.affirmation1, forKey: self.key1)
                        self.userDefaults.set(now, forKey: "LastFetchedAffirmation")
                    }
                    if num == 2 {
                        self.affirmation2 = affirmation!.affirmation
                        self.userDefaults.set(self.affirmation2, forKey: self.key2)

                    }
                    if num == 3 {
                        self.affirmation3 = affirmation!.affirmation
                        self.userDefaults.set(self.affirmation3, forKey: self.key3)

                    }

                }
            }.resume()
        }
    }
}


struct Affirmation: Decodable, Hashable {
    let affirmation: String
}
