//
//  HomeView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import SwiftUI

extension VerticalAlignment {
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                Text("Center")
                    .background(.blue)
                    .onTapGesture {
                        print("Global center \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY) y")
                        print("Local center \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY) y")
                        print("Custom center \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY) y")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}

struct HomeView: View {
    @Binding var user: User?
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddFoodActive = false
    @State private var isAddLogActive = false
    @State private var isTodayPresent = false
    private let router = Navigator()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollableCardList(todayPresent: $isTodayPresent)
                HStack {
                    NavigationLink(
                        destination: router.view(for: .addFood($isAddFoodActive)),
                        isActive: $isAddFoodActive
                    ) {
                            Text("Add food")
                                .padding()
                                .background(.green)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    if (!isTodayPresent) {
                        NavigationLink(
                            destination: router.view(for: .addLog($isAddLogActive)),
                            isActive: $isAddLogActive
                        ) {
                            Text("Add log")
                                .padding()
                                .background(.green)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    } else {
                        NavigationLink(
                            destination: router.view(for: .addLog($isAddLogActive)),
                            isActive: $isAddLogActive
                        ) {
                            Text("Update log")
                                .padding()
                                .background(.orange)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .navigationTitle("Calorie Counter")
        }
    }
    
//    struct LogList: View {
//        var body: some View {
//            List {
//                ForEach(logs) { log in
//                    Navigator.navigate(.viewLog(log)) {
//                        LogCard(log: log)
//                    }
//                }
//                .onDelete(perform: deleteLog)
//            }
//        }
//    }
//
//    func deleteLog(indices: IndexSet) {
//        indices.map{ logs[$0] }.forEach(viewContext.delete)
//
//    }
}

struct ScrollableCardList: View {
    @Binding var todayPresent: Bool
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.timestamp, ascending: true)],
        animation: .default)
    private var logs: FetchedResults<Log>
    @State private var selectedLog: Log? = nil
    @State private var day = Date()
    @State private var isRightPressed = false
    @State private var isLeftPressed = false
    var body: some View {
        Text(verbatim: "\(day.get(.month))/\(day.get(.day))/\(day.get(.year))")
            .font(.title)
        Spacer()
        let selectedLog = logs.last(where: {$0.timestamp!.get(.day) == day.get(.day)})
        if day.isToday() {
            if selectedLog != nil {
                ViewLog(log: selectedLog!)
                    .onAppear {
                        todayPresent = true
                    }
            } else {
                Text("No log for today yet")
                    .padding(.bottom, 50)
            }
        } else {
            if selectedLog != nil {
                ViewLog(log: selectedLog!)
            } else {
                Text("No log for this day")
                    .padding(.bottom, 50)
            }
        }
        HStack {
            Image(systemName: "arrow.left")
                .padding()
                .frame(maxWidth: 100, maxHeight: 50)
                .background(.gray)
                .opacity(isLeftPressed ? 0.4 : 1.0)
                .onTapGesture {
                    day = day.dayBefore
                }
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isLeftPressed = true
                    }
                } onRelease: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isLeftPressed = false
                    }
                }
            Image(systemName: "arrow.right")
                .padding()
                .frame(maxWidth: 100, maxHeight: 50)
                .background(.gray)
                .opacity(isRightPressed ? 0.4 : 1.0)
                .onTapGesture {
                    if (!day.isToday()) {
                        day = day.dayAfter
                    }
                }
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isRightPressed = true
                    }
                } onRelease: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isRightPressed = false
                    }
                }
            

        }
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({_ in
                        onPress()
                    })
                    .onEnded({_ in
                        onRelease()
                    }))
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func isToday() -> Bool {
        return Date().get(.day) == self.get(.day)
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}

struct HomeView_PreviewHelper: View {
    @State private var user: User? = User.example
    var body: some View {
        HomeView(user: $user)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_PreviewHelper().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
