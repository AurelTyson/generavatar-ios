//
//  MainNavigationCoordinator.swift
//  Generavatar
//
//  Created by Aurélien Tison on 02/10/2021.
//

import RxCocoa
import RxSwift
import UIKit
import XCoordinator

public enum MainNavigationRoute: Route {
    case avatar
    case pop
    case dismiss
}

public final class MainNavigationCoordinator: NavigationCoordinator<MainNavigationRoute> {
    
    // MARK: NavigationCoordinator
    
    override public func prepareTransition(for route: MainNavigationRoute) -> NavigationTransition {
        
        switch route {
            
        case .avatar:
            let vc = AvatarViewController.instantiateFromNib()
            let vm = AvatarViewModel(router: self.unownedRouter)
            vc.bind(to: vm)
            return .push(vc)
            
        case .pop:
            return .pop()
            
        case .dismiss:
            return .dismiss()
            
        }
        
    }
    
}
