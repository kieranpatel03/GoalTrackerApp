//
//  HomeView.swift
//  HabitTracker
//
//  Created by Kieran on 02/07/2022.
//

import SwiftUI

private struct Task: Codable {
    var id: Int;
    var completed_by: String;
    var title: String;
    var description: String?;
    var amount: Int?;
}

struct HomeView: View {
    
    private let mistyWhite = Color(red: 232 / 255, green: 241 / 255, blue: 241 / 255)
    
    @State private var Tasklist: [Task] = []
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle").resizable().frame(width: 50, height: 50).padding(25)
                Spacer()
                Text("Goals").bold().font(.largeTitle)
                Spacer()
                
                Button(action: {
                    
                } label: Image(systemName: "plus.square").resizable().frame(width: 50, height: 50).padding(25))
            }
            Group {
                ForEach(Tasklist, id: \.id) { theTask in
                    VStack {
                        Text(theTask.title).padding(1)
                        if(!(theTask.description ?? "").isEmpty) {
                            Text(theTask.description!)
                        }
                        Text("Complete within " + secondsToDaysHoursMinutesSeconds(Int((string_to_date(from: theTask.completed_by, format: "EEE, d MMM yyyy HH:mm:ss ZZZ") - Date())))).padding(1)
                    }.frame(maxWidth: .infinity).padding(5).background(mistyWhite).cornerRadius(15).padding(5)
                    }
                }
            Spacer()
        }.background(Color(.systemPink)).task {
            await loadTasks()
        }
    }
    
    func loadTasks() async {
        print("ok")
        do {
            let data = try await alteringTable(route: "select", parameters: ["table": "tasks"])
            Tasklist = try! JSONDecoder().decode([Task].self, from: data)
        } catch alteringTableErrors.InvalidUrl {
            print("Invalid URL")
        } catch alteringTableErrors.InvalidResponse {
            print("Not a valid response")
        } catch alteringTableErrors.NotValidParameters {
            print("Invalid parameters.")
        } catch {
            print("Unknown error.")
        }
        
    }
}
    
    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
