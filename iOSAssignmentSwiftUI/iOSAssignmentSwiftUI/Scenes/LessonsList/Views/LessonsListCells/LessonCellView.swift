//
//  LessonCellView.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LessonCellView: View {
    var lesson: Lessons?
    
    var body: some View {
        VStack {
            HStack{
                
                WebImage(url: URL(string: lesson?.thumbnail ?? "")!)
                    .onSuccess(perform: { image, data, cache in
                        
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .clipped()
                    .cornerRadius(5)
                
                Spacer()
                VStack (alignment: .leading) {
                    Spacer()
                    HStack {
                        Text(lesson?.name ?? "")
                            .foregroundColor(Color.customTextColor)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing,16)
                            .foregroundColor(Color.blue)
                        
                    }
                    .padding(.bottom,16)
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.separatorColor)
                    
                }
                .padding(.leading,16)
                
            }
            .padding([.leading,.bottom])
            
        }
        .listRowInsets(EdgeInsets())
        .background(Color.customBackgroundColor)
    }
}

struct LessonCellView_Previews: PreviewProvider {
    static var previews: some View {
        LessonCellView()
    }
}
