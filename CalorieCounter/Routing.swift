//
//  Routing.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

//protocol Routing {
//    associatedtype Route
//    associatedtype View: SwiftUI.View
//
//    @ViewBuilder func view(for route: Route) -> Self.View
//}
//
//enum AppRoute {
//    case viewFood
//    case viewLog
////    case addFood
////    case addLog
//}
//
//struct AppRouter: Routing {
//
//    func view(for route: AppRoute) -> some View {
//        switch route {
//        case .viewFood:
//            ViewFood()
//
//        case .viewLog:
//            ViewLog()
//
////        case .addFood:
//////            AddFood()
////
////        case .addLog:
//////            AddLog()
//
//        }
//    }
//}

enum Route {
    case viewFood
    case viewLog(Log)
    case addFood(Binding<Bool>)
    case addLog(Binding<Bool>)
}

struct Navigator {
    
    @ViewBuilder func view(for route: Route) -> some View {
            switch route {
            case .viewFood:
                ViewFood()
    
            case .viewLog(let log):
                ViewLog(log: log)
    
            case .addFood(let active):
                AddFood(isAddFoodActive: active)
    
            case .addLog(let active):
                AddLog(isAddLogActive: active)
    
            }
    }
        
    @ViewBuilder static func navigate<T: View>(_ route: Route, content: () -> T) -> some View {
        
        switch route {
        case .viewFood:
            NavigationLink(destination: ViewFood()) {
                content()
            }
        case .viewLog(let log):
            NavigationLink(destination: ViewLog(log: log)) {
                content()
            }
        case .addFood(let active):
            NavigationLink(destination: AddFood(isAddFoodActive: active), isActive: active) {
                content()
            }
        case .addLog(let active):
            NavigationLink(destination: AddLog(isAddLogActive: active), isActive: active) {
                content()
            }
        }
    }
}
