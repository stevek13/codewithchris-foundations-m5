//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Steve Kite on 4/24/22.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]
        // Lesson card
        ZStack (alignment: .leading){
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack () {
                Text(String(index + 1))
                    .bold()
                    .padding()
                VStack (alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
                
            }
            
        }
        .padding(.bottom, 10)
    }
}


