//
//  AvatarViewController.swift
//  Generavatar
//
//  Created by Aurélien Tison on 02/10/2021.
//

import MKGradientView
import RxCocoa
import RxGesture
import RxSwift
import UIKit

public final class AvatarViewController: UIViewController, BindableType {
    
    // MARK: Outlets
    
    @IBOutlet private weak var avatarContainerView: UIView!
    @IBOutlet private weak var avatarGradientBackgroundView: GradientView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var changeGradientButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: Attributes
    
    public var viewModel: AvatarViewModel!
    
    private let didLongPress = PublishSubject<Void>()
    private let saveImage = PublishSubject<UIImage>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = L10n.Avatar.title
        
        // Avatar container
        self.avatarContainerView.backgroundColor = .clear
        
        // Gradient
        self.avatarGradientBackgroundView.contentScaleFactor = 0.1
        self.avatarGradientBackgroundView.clipsToBounds = true
        self.avatarGradientBackgroundView.layer.cornerCurve = .continuous
        self.avatarGradientBackgroundView.layer.cornerRadius = 75
        
        // Change gradient button
        self.changeGradientButton.setTitle(L10n.Avatar.changeGradient, for: .normal)
        
        // Save button
        self.saveButton.setTitle(L10n.Avatar.saveAvatar, for: .normal)
        self.saveButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                // Render avatar
                self?.renderAvatar()
                
            })
            .disposed(by: self.disposeBag)
        
        // Long press on avatar
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.rx.event.when(.began)
            .map({ _ in })
            .bind(to: self.didLongPress)
            .disposed(by: self.disposeBag)
        self.avatarContainerView.addGestureRecognizer(longPressGesture)
        
    }
    
    // MARK: Bind
    
    public func bindViewModel() {
        
        // Input for viewModel
        let input = AvatarViewModel.Input(
            didLongPress: self.didLongPress,
            didTapChangeGradient: self.changeGradientButton.rx.tap.asObservable(),
            saveImage: self.saveImage
        )
        
        // Transform input to output
        let output = self.viewModel.transform(input: input)
        
        // Avatar image
        output.avatarImage
            .drive(self.avatarImageView.rx.image)
            .disposed(by: self.disposeBag)
        
        // Gradient colors
        output.gradientColors
            .drive(onNext: { [weak self] (colors: [[UIColor]]) in
                
                // Colors 1
                if colors.count > 1 {
                    self?.avatarGradientBackgroundView.colors = colors[0]
                }
                else {
                    self?.avatarGradientBackgroundView.colors = []
                }
                
                // Colors 2
                if colors.count > 1 {
                    self?.avatarGradientBackgroundView.type = .bilinear
                    self?.avatarGradientBackgroundView.colors2 = colors[1]
                }
                else {
                    self?.avatarGradientBackgroundView.colors2 = []
                }
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
    // MARK: Methods
    
    private func renderAvatar() {
        
        // Render the avatar view as image
        let renderer = UIGraphicsImageRenderer(size: self.avatarContainerView.bounds.size)
        let image = renderer.image { ctx in
            self.avatarContainerView.drawHierarchy(in: self.avatarContainerView.bounds, afterScreenUpdates: true)
        }
        
        // Save it
        self.saveImage.onNext(image)
        
    }
    
}
