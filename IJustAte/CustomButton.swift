//
//  Button.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/28/22.
//

import SwiftUI

struct CustomButton<Content: View>: View {
    var opacity: CGFloat
    @ViewBuilder var content: Content
    @State private var isPressed = false
    var body: some View {
        content
            .opacity(isPressed ? 0.4 : opacity)
            .pressEvents {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPressed = true
                }
            } onRelease: {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPressed = false
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
