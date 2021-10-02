//
//  BindableType.swift
//  Generavatar
//
//  Created by Aurélien Tison on 02/10/2021.
//
// Source: https://github.com/quickbirdstudios/XCoordinator-Example/blob/master/XCoordinator-Example/Utils/BindableType.swift
//

import Foundation
import UIKit

protocol BindableType: AnyObject {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
    
}

extension BindableType where Self: UIViewController {
    
    func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        loadViewIfNeeded()
        self.bindViewModel()
    }
    
}

extension BindableType where Self: UITableViewCell {
    
    func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        self.bindViewModel()
    }
    
}

extension BindableType where Self: UICollectionViewCell {
    
    func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        self.bindViewModel()
    }
    
}
