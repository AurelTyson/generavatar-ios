//
//  AvatarViewModel.swift
//  Generavatar
//
//  Created by Aurélien Tison on 02/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import XCoordinator
import UIKit

public class AvatarViewModel {
    
    // MARK: Input / Output
    
    public struct Input {
        let didLongPress: Observable<Void>
        let didTapChangeGradient: Observable<Void>
        let saveImage: Observable<UIImage>
    }
    
    public struct Output {
        let avatarImage: Driver<UIImage?>
        let gradientColors: Driver<[[UIColor]]>
    }
    
    // MARK: Attributes
    
    private let router: UnownedRouter<MainNavigationRoute>
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    public init(router: UnownedRouter<MainNavigationRoute>) {
        
        // Init
        self.router = router
        
    }
    
    // MARK: Transform
    
    public func transform(input: AvatarViewModel.Input) -> AvatarViewModel.Output {
        
        // Avatar image
        let avatarImage = BehaviorRelay<UIImage?>(value: nil)
        
        // Gradient colors
        let gradientColors = BehaviorRelay<[[UIColor]]>(value: [])
        gradientColors.accept([[.red, .yellow], [.blue, .cyan]])
        
        // Long press
        input.didLongPress
            .subscribe(onNext: { _ in
                
                // Get image from pastboard
                guard let image = UIPasteboard.general.image else {
                    print(">> No image in pasteboard")
                    return
                }
                
                // Save image
                avatarImage.accept(image)
                
            })
            .disposed(by: self.disposeBag)
        
        // Change gradient
        input.didTapChangeGradient
            .subscribe(onNext: { _ in
                
                var newColors = gradientColors.value
                newColors.shuffle()
                newColors[0].shuffle()
                newColors[1].shuffle()
                gradientColors.accept(newColors)
                
            })
            .disposed(by: self.disposeBag)
        
        // Save
        input.saveImage
            .subscribe(onNext: { [weak self] (image: UIImage) in
                
                // Save image to photo album
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil) // #selector(self?.saveError), nil)
                
            })
            .disposed(by: self.disposeBag)
        
        // Output
        return Output(
            avatarImage: avatarImage.asDriver(),
            gradientColors: gradientColors.asDriver()
        )
        
    }
    
    // MARK: Methods
    
//    @objc public func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        print("Save finished!")
//    }
    
}
