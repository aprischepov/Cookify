//
//  CommunityViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 5.07.23.
//

import Foundation

final class CommunityViewModel: ObservableObject {
//    MARK: Proeprties
    private var firebaseManager: FirebaseProtocol = FirebaseManager()
    @Published var reviews: [Review] = []
//    View Properties
    @Published var dataCondition: DataCondition = .loaded
    @Published var errorMessage: String = "" {
        didSet {
            showError.toggle()
        }
    }
    @Published var showError: Bool = false
    
//    MARK: Methods
//    Fetch Review
    func fetchReviews() async {
        await MainActor.run(body: {
            dataCondition = .loading
        })
            do {
                let fetchedReviws = try await firebaseManager.fetchReviews()
                await MainActor.run(body: {
                    reviews = fetchedReviws
                    if reviews.isEmpty {
                        dataCondition = .empty
                    } else {
                        dataCondition = .loaded
                    }
                })
            } catch {
                await errorHandling(error)
            }
    }
    
//    Error Handling
    private func errorHandling(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
        })
    }
}
