//
//  VarkResultsView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/17/23.
//

import SwiftUI
import Charts

struct VarkResultsView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showInfo = true
    @State private var Category = "Help"
    
    var varkResults: VarkResponse
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Vark Results")
                    .font(.title)
                    .padding([.top, .leading, .bottom])
                
                Button(action: {
                    self.showInfo.toggle()
                    self.Category = "Visual"
                }, label: {
                    Label("", systemImage: "info.circle")
                        .padding(.all, 0.0)
                        .scaleEffect(1.3)
                    
                })
                
                Spacer()
            }

            
            Chart{
                BarMark (
                    x: .value("Category", "Visual"),
                    y: .value("Score", varkResults.a)
                )
                
                
                BarMark (
                    x: .value("Category", "Auditory"),
                    y: .value("Score", varkResults.b)
                )
                
                BarMark (
                    x: .value("Category", "Relational"),
                    y: .value("Score", varkResults.c)
                )
                
                BarMark (
                    x: .value("Category", "Kinesthetic"),
                    y: .value("Score", varkResults.d)
                )
                
    
            }
            .chartYScale(domain: 0...10)
            .chartXAxis {
                AxisMarks{
                    cat in
                    AxisValueLabel(){
                        if let strCat = cat.as(String.self) {
                            Text(strCat)
                                .bold()
                                .font(.subheadline)
                        }
                        
                    }
                    
                }
                

            }
            .padding()
            .sheet(isPresented: $showInfo) {
                VarkCatInfoView()
            }
            
        }
    }
}


struct VarkCatInfoView: View {
    
    @State private var currentCat: Category = .Visual
    
    enum Category {
        case Visual
        case Auditory
        case Relational
        case Kinesthetic
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("MatteAqua"))
                    .frame(height: 80)
                
                Text("Learning Styles in Action")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            }
            
            HStack {
                Button(action: {
                    // button action here
                    currentCat = .Visual
                }) {
                    Text("Visual")
                        .padding(4)
                }

                Button(action: {
                    // button action here
                    currentCat = .Auditory
                }) {
                    Text("Auditory")
                        .padding(4)
                    
                }

                Button(action: {
                    // button action here
                    currentCat = .Relational
                }) {
                    Text("Relational")
                        .padding(4)
                }
  
                Button(action: {
                    // button action here
                    currentCat = .Kinesthetic
                }) {
                    Text("Kinesthetic")
                        .padding(4)
                }
            }
            
            Divider()
            
            switch currentCat {
            case .Visual:
                VARKLearningStyleView(style: "Visual",
                    learnBest: "You learn best when information is presented visually in a written language format (words).",
                    strategies: ["• Read, take notes, and color-code.",
                                 "Annotate with words and short phrases.",
                                "• Make flashcards of vocabulary words.",
                                "• Use diagrams, charts, or illustrations."],
                    benefits: ["• Presentations that list the highlights of a lecture",
                              "• Following an outline",
                              "• Reading from textbooks and class notes"])
            case .Auditory:
                VARKLearningStyleView(style: "Auditory",
                    learnBest: "You learn best by hearing new information and discussing it with others.",
                    strategies: ["• Join a study group to assist you in learning material or work with a study buddy.",
                                "• When studying alone, say the material out loud. Record lectures and listen to audio books.",
                                "• Use music and rhymes to remember the sequences and details of the subject matter.",
                                "• Reason through solutions to problems by talking out loud to yourself or with a partner."],
                    benefits: ["• Listening to a lecture and participating in group discussions",
                              "• Listening to audio recordings and reading quietly out loud",
                              "• Recalling an idea by hearing the way someone said it or the way you previously repeated it out loud"])
            case .Relational:
                VARKLearningStyleView(style: "Relational",
                    learnBest: "You learn best when you feel like you belong, and you interact with others in the learning process.",
                    strategies: ["• First, look at the BIG picture. Then, consider how the details relate to that BIG picture.",
                                "• Study in groups, discuss information, and work in a relaxed environment. Teach someone else the material.",
                                "• Use association to deepen the meaning of a subject: Relate the subject matter to how it affects something important to you.",
                                "• Build relationships with your teachers and advocate for your learning style."],
                    benefits: ["• Creating relationships",
                              "• Drawing on background knowledge to see how things relate and considering the BIG picture first and then the details",
                              "• Personalizing the context of the subject so it has relevant meaning and importance to how it affects you or your world"])
            case .Kinesthetic:
                VARKLearningStyleView(style: "Kinestetic",
                    learnBest: "You learn best when physically engaged in \"hands on\" activities where you can touch or manipulate objects.",
                    strategies: ["• To help you stay focused during lectures, sit near the front of the room and take notes. Jot down key words and draw pictures to help you remember the information you are hearing.",
                                "• When studying, walk back and forth with your textbook, notes, or flashcards in hand and read the information out loud.",
                                "• Think of ways to make your learning tangible, something you can put your hands on (models, math manipulatives, flashcards).",
                                "• Spend time in the field (i.e., a museum or historical site) to gain first-hand experience of the subject matter."],
                    benefits: ["• Lab settings where you can manipulate materials to learn new information",
                              "• Being physically active in the learning environment",
                              "• Instructors who encourage in-class demonstrations, experiences, and field work"])
            }
            
            
            Spacer()
            
        }
    }
}

struct VARKLearningStyleView: View {
    var style: String
    var learnBest: String
    var strategies: [String]
    var benefits: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(style)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(3)
                    Spacer()
                }
                
                
                Text(learnBest)
                
                Text("You Benefit From:")
                    .font(.headline)
                    .bold()
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .underline()
                    .foregroundColor(Color("LightBlue"))
                ForEach(benefits, id: \.self) { benefit in
                    Text(benefit)
                        .padding([.top, .bottom, .trailing], -1.0)
                }
                
                Text("Strategies:")
                    .font(.headline)
                    .bold()
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .underline()
                    .foregroundColor(Color("MatteOrange"))
                
                ForEach(strategies, id: \.self) { strategy in
                    Text(strategy)
                        .padding(.vertical, -1.0)
                }
                
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

struct VarkResultsView_Previews: PreviewProvider {
    static var previews: some View {
        VarkResultsView(varkResults: VarkResponse(uuid: "ergoineoinfw", dateTaken: Date(),
                                                  a: 4, b: 5, c: 1, d: 2))
        .environmentObject(ViewRouter())
//        VarkCatInfoView()
    }
}
