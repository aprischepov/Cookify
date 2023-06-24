//
//  MainViewModel.swift
//  Cookify
//
//  Created by Artem Prishepov on 23.06.23.
//

import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    @Published var homeViewModel = HomeViewModel()
    @Published var favoritesViewModel = FavoritesViewModel()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        homeViewModel
            .$listFavoritesRecipes
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.listFavoritesRecipes, on: favoritesViewModel)
            .store(in: &cancellable)
        
        favoritesViewModel.subject.sink { complition in
            switch complition {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        } receiveValue: { [weak self] indexSet in
            guard let self else { return }
            self.homeViewModel.listFavoritesRecipes.remove(atOffsets: indexSet)
        }.store(in: &cancellable)

    }
}
