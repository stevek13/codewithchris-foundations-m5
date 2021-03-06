//
//  ContentModel.swift
//  LearningApp
//
//  Created by Steve Kite on 4/22/22.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    // Current Lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        getLocalData()

        getRemoteData()
    }
    
    // MARK: - Data Methods
    
    // Parse local included JSON data
    func getLocalData() {
        // get URL to json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules  to modules property
            self.modules = modules
            
        } catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        } catch {
            // Log error
            print("Couldn't parse style data")
        }
    }
    
    // Download remote JSON file and parse it
    func getRemoteData() {
        // String path to remote data
        let urlString = "https://stevek13.github.io/learningapp-data/data2.json"
        
        // Create URL object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // Check if there is an error
            guard error == nil else {
                // There was an error
                return
            }
            // Handle the response
            // Try to decode the json into an array of modules
            do {
            let decoder = JSONDecoder()
           
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property
                self.modules += modules
            }
            catch {
                // Couldn't parse JSON
            }
        }
        // Kick off the dataTask
        dataTask.resume()
    }
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int) {
        
        //Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    func beginLesson(_ lessonIndex: Int) {
        
        //Check that the lesson index is within range of module indes
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        // Advance the lesson Index
        currentLessonIndex += 1
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    func hasNextLesson() -> Bool {
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
        
    }
    
    func beginTest(_ moduleId:Int) {
        // Set the current module
        beginModule(moduleId)
        
        // Set the current Question
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        // Check that it's within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            // If not, reset the propertiess
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    
    // MARK: - Code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        //Add the styling data
        if styleData != nil  {
            data.append(self.styleData!)
        }
        //Add the html data
        data.append(Data(htmlString.utf8))
        
        
        //Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        return resultString
    }
}
