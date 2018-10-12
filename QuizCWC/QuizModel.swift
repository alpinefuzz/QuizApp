//
//  QuizModel.swift
//  QuizCWC
//
//  Created by Vitaliy Kurbatov on 02/02/2018.
//  Copyright © 2018 Vitaliy Kurbatov. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionsRetrieved(questions:[Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        getRemoteJsonFile()
    }
    
    func getLocalJsonFile() {
        
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json")
        
        guard path != nil else {
            print("No JSON File")
            return
        }
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            delegate?.questionsRetrieved(questions: array)
        } catch {
            print("can't create data object from file")
        }
    }
    
    func getRemoteJsonFile() {
        
//        get a url obj fram a string
        let stringURL = "https://codewithchris.com/code/QuestionData.json"
        let url = URL(string: stringURL)
        
        guard url != nil else {
            print("error. couldnt get a URL Obj")
            return
        }
    
        let session = URLSession.shared
    
//        get a Datatask object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                
                do {
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.delegate?.questionsRetrieved(questions: array)
                    }
                } catch {
                    print("Cant parse json")
                }
            }
        }
        dataTask.resume()
    }
}
