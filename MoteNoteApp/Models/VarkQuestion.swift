//
//  VarkQuestion.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/16/23.
//

import Foundation
struct VarkQuestion: Codable {
    var question: String
    var a: String
    var b: String
    var c: String
    var d: String
}

struct VarkAllQuestions: Codable {
    let questions: [VarkQuestion]
}

struct VarkResponse: Codable {
    // class for total responses of VARK assesment
    
    // to identify user
    var uuid: String
    
    // to tell when it was taken
    var dateTaken: Date
    
    // count of each response
    var a: Int
    var b: Int
    var c: Int
    var d: Int
    
    
    
}

// helper functions to read in data
func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            print(data)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func parse(jsonData: Data) -> VarkAllQuestions? {
    do {
        let decodedData = try JSONDecoder().decode(VarkAllQuestions.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}

func loadJson(filename fileName: String) -> [VarkQuestion]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(VarkAllQuestions.self, from: data)
            return jsonData.questions
        } catch {
            print("error:\(error)")
        }
    }
    
    print("ERRRRRRROOORRRRRRRRRRR")
    return nil
}


