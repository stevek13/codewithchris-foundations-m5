//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Steve Kite on 4/26/22.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        
        let lesson = model.currentLesson
       
        let url = URL(string:  Constants.videoHostUrl + (lesson?.video ?? ""))
       
        VStack {
            
        // Only show video if we get a valid url
        if url != nil {
           
            VideoPlayer(player: AVPlayer(url: url!))
                .cornerRadius(10)
        }
        //Description
        CodeTextView()
            
        //Next Lesson Button
        // Show button only if there is a next lesson
        if model.hasNextLesson() {
            Button {
                model.nextLesson()
            } label: {
                ZStack {
                    Rectangle()
                        .frame(height: 48)
                        .foregroundColor(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                        .foregroundColor(Color.white)
                        .bold()
                }
            }
        }
        
        
    }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
}
    
}
struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
