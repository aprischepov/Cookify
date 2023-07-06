//
//  CommunityViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 5.07.23.
//

import Foundation
import Combine

final class CommunityViewModel: ObservableObject {
    //    MARK: Proeprties
    let subject: PassthroughSubject<ActionsWithRecipes, Never>
    @Published var reviews: [Review] = []
    
    //    MARK: Init
    init(subject: PassthroughSubject<ActionsWithRecipes, Never>) {
        self.subject = subject
    }
    
    //    MARK: Methods
    func sendAction(actionType: ActionsWithRecipes) {
        switch actionType {
        case .reloadReviwsList:
            subject.send(.reloadReviwsList)
        default: break
        }
    }
}
