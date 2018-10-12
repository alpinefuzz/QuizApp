//
//  Question.swift
//  QuizCWC
//
//  Created by Vitaliy Kurbatov on 02/02/2018.
//  Copyright © 2018 Vitaliy Kurbatov. All rights reserved.
//

import Foundation

struct Question: Codable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
}
