//
//  VarkAssessment.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/16/23.
//

import SwiftUI
import Foundation

struct VarkAssessment: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var varkViewModel : VarkViewModel
    
    @State private var currentQuestion = 0
    
    @State private var aResponses = [Bool] (repeating: false, count: 10)
    @State private var bResponses = [Bool] (repeating: false, count: 10)
    @State private var cResponses = [Bool] (repeating: false, count: 10)
    @State private var dResponses = [Bool] (repeating: false, count: 10)
    
    @State private var showResults = false
    
    var cols = [Color("MatteBlue"), Color("MatteGreen"), Color("MatteYellow"), Color("MattePurple"), Color("MatteOrange"), Color("MatteAqua"), Color.cyan, Color("MatteGreen"), Color.mint, Color("MattePurple")]
    
    
    
    var body: some View {
        
        if !showResults {
            VStack{
                Text("VARK Assessment")
                    .font(.title)
                
                Divider()
                
                Text("What's Your Learning Style: Visual, Auditory, Relational, Kinesthetic? Read the following questions and choose one or more response that best explains your preference(s).")
                    .padding(10)
            
                Divider()
                
                // Questions

                HStack {
                    Text("Question \(currentQuestion + 1)")
                        .padding()

                    Spacer()
                    
                    Text("\(currentQuestion + 1)/10")
                        .padding()
                }

                Group {
                    VStack(alignment: .leading) {
                        Text(varkViewModel.varkAllQuestions[currentQuestion].question)
                            .font(.headline)
                            .cornerRadius(10)
                            .frame(width: 300, height: 50)
                            .padding()
                            .transition(.slide)
                        
                        Toggle(varkViewModel.varkAllQuestions[currentQuestion].a, isOn: $aResponses[currentQuestion])
                            .toggleStyle(CheckToggleStyle())
                            .padding(5)
                            .transition(.slide)
                        
                        Toggle(varkViewModel.varkAllQuestions[currentQuestion].b, isOn: $bResponses[currentQuestion])
                            .toggleStyle(CheckToggleStyle())
                            .padding(5)
                        
                        Toggle(varkViewModel.varkAllQuestions[currentQuestion].c, isOn: $cResponses[currentQuestion])
                            .toggleStyle(CheckToggleStyle())
                            .padding(5)
                        
                        Toggle(varkViewModel.varkAllQuestions[currentQuestion].d, isOn: $dResponses[currentQuestion])
                            .toggleStyle(CheckToggleStyle())
                            .padding(5)
                    }
                    .frame(width: 350, height: 400)
                    .background(cols[currentQuestion])
                    .cornerRadius(10)
                    
                    
                    HStack {
                        // Back Button - decrements currentQuestion
                        Button(action: {
                            
                            if currentQuestion != 0 {
                                withAnimation(.easeOut) {
                                    currentQuestion-=1
                                }

                            }
                        }) {
                            Text("Back")
                        }
                        .padding()
                        
                        Spacer()
                        
                        // if on last question, make the "next" button a submit button
                        if currentQuestion == 9 {
                            // Next Button - increments currentQuestion
                            Button(action: {
                                
                                // set up object that needs to be submitted
                                let responses = VarkResponse(uuid: varkViewModel.uuid,
                                                             dateTaken: Date(),
                                                             a:  aResponses.filter{$0 == true}.count,
                                                             b: bResponses.filter{$0 == true}.count,
                                                             c: cResponses.filter{$0 == true}.count,
                                                             d: dResponses.filter{$0 == true}.count
                                )
                                
                                // submit
                                submitVarkResult(response: responses)
                                
                                // send to results page
                                showResults = true
                            }){
                                Text("Submit")
                            }
                            
                            .padding()
                        } else{
                            // Next Button - increments currentQuestion
                            // Don't need to check if 9 bc if it is 9 it will be submit button
                            Button(action: {
                                withAnimation {
                                    currentQuestion+=1
                                }

                            }){
                                Text("Next")
                            }
                            .padding()
                        }
                    }
                }
            }
        } else {
            // show results
            VarkResultsView(varkResults: VarkResponse(uuid: varkViewModel.uuid,
                                                      dateTaken: Date(),
                                                      a: aResponses.filter{$0 == true}.count,
                                                      b: bResponses.filter{$0 == true}.count,
                                                      c: cResponses.filter{$0 == true}.count,
                                                      d: dResponses.filter{$0 == true}.count))
            .environmentObject(ViewRouter())
        }
            
    }
        
        

    
    func submitVarkResult(response: VarkResponse) {
        varkViewModel.addVark(response: response) {
            // anything that needs to be done after it is completed
            // set varkCompleted to true in the profile
            profileViewModel.profile?.completedVARK = true

            profileViewModel.add(user: profileViewModel.profile!) {
                profileViewModel.sync()
            }
        }
        
    }
            
            
}



struct VarkAssessment_Previews: PreviewProvider {
    static var previews: some View {
        VarkAssessment()
            .environmentObject(ViewRouter())
            .environmentObject(ProfileViewModel())
            .environmentObject(VarkViewModel())
    }
}
