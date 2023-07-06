//
//  PreloadView.swift
//  Cookify
//
//  Created by Artem Prishepov on 6.07.23.
//

import SwiftUI

struct PreloadView: View {
    @State private var firstPhase = false
    @State private var secondPhase = false
    @EnvironmentObject var preloadManager: PreloadScreenManager
    private let timer = Timer.publish(every: 0.65, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Image("cookifyIcon")
                    .scaleEffect(secondPhase ? UIScreen.main.bounds.size.height / 4 : 1)
                Image("cookifyName")
            }
            .scaleEffect(firstPhase ? 0.7 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color.white
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            switch preloadManager.state {
            case .first:
                withAnimation(.spring()) {
                    firstPhase.toggle()
                }
            case .second:
                withAnimation(.easeInOut) {
                    secondPhase.toggle()
                }
            default: break
            }
        }
    }
}

struct PreloadView_Previews: PreviewProvider {
    static var previews: some View {
        PreloadView()
            .environmentObject(PreloadScreenManager())
    }
}

enum PreloadScreenPhase {
    case first
    case second
    case completed
}

final class PreloadScreenManager: ObservableObject {
    @Published private(set) var state: PreloadScreenPhase = .first
    
    func dismiss() {
        self.state = .second
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .completed
        }
    }
}
