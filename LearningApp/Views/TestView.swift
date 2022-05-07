//
//  TestView.swift
//  LearningApp
//
//  Created by Steve Kite on 5/2/22.
// Stopped at 16:50

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted:Bool = false
    
    var body: some View {
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0 ..< model.currentQuestion!.answers.count, id: \.self) { index in
                            Button  {
                                // Track the selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    if submitted == false {
                                    RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                        .frame(height: 48)
                                    } else {
                                        // answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex{
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                    } else if index == model.currentQuestion!.correctIndex {
                                        // This button is the correct answer
                                        RectangleCard(color: Color.green)
                                            .frame(height: 48)
                                    } else {
                                        RectangleCard(color: Color.white)
                                            .frame(height: 48)
                                    }
                                    }
                                Text(model.currentQuestion!.answers[index])
                            }
                            

                        }
                            .disabled(submitted)
                        }
                        
                    }
                    .accentColor(.black)
                    .padding()
                }
                // Button
                // Check the answer and increment the count if correct
                Button {
                    // Change the submitted state to true so the answer cannot be changed again

                    submitted = true

                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                        
                    }
                } label: {
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Submit")
                            .bold()
                            .foregroundColor(Color.white)
                        
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        else {
            // Test hasn't loaded
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
