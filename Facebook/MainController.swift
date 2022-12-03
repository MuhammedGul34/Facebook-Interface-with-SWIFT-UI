//
//  MainController.swift
//  Facebook
//
//  Created by Muhammed Gül on 22.11.2022.
//

import UIKit
import SwiftUI
import LBTATools


class PostCell : LBTAListCell<String> {
   
        let imageView = UIImageView(backgroundColor: .blue)
        let nameLabel = UILabel(text: "Name Label")
        let dateLAbel = UILabel(text: "Friday at 11:11 AM")
        let postTextLabel = UILabel(text: "Here is my post text")
        
       // let imageViewGrid = UIView(backgroundColor: .yellow)
        
        let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        
        stack(hstack(imageView.withHeight(40).withWidth(40),
                     stack(nameLabel, dateLAbel),
                     spacing: 8).padLeft(12).padRight(12).padTop(12),
               postTextLabel,
              photosGridController.view,
                spacing: 8)
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StoryPhotoCell: LBTAListCell<String>{
    
    override var item: String!{
        didSet {
            imageView.image = UIImage(named: item)
            
        
        }
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Lee Ji EUn", font: .boldSystemFont(ofSize: 14), textColor: .white)
    
    override func setupViews() {
        imageView.layer.cornerRadius = 10
    
        stack(imageView)
        
        setupGradientLayer()
        
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer(){
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}

class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["story_picture", "story_picture2","story_picture3","story_picture"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
}

class MainController : LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 14, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(UIColor(white: 0.9, alpha: 1))
        
        self.items = ["Hello", "World", "1", "2"]
        
        setupNavBar()
    }
    
    let fbLogoImageView = UIImageView(image: UIImage(named: "fb_logo"), contentMode: .scaleAspectFill)
    lazy var searchButton = UIButton(image: UIImage(named: "search")!, tintColor: .black)
    
    lazy var messageButton = UIButton(image: UIImage(named: "messenger")!, tintColor: .black)
    
    fileprivate func setupNavBar(){
        let coverWhiteView = UIView(backgroundColor: .white)
        view.addSubview(coverWhiteView)
        coverWhiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        coverWhiteView.constrainHeight(safeAreaTop)

        
        let width = view.frame.width - 120 - 16 - 60
        
        let titleView = UIView(backgroundColor: .white)
        navigationItem.titleView = titleView
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        
       
        
        
        titleView.hstack(fbLogoImageView.withWidth(120), UIView(backgroundColor: .clear).withWidth(600), searchButton.withWidth(60))
        navigationItem.titleView = titleView

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        print(scrollView.contentOffset.y)
        let offset = scrollView.contentOffset.y + safeAreaTop
        
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
        [fbLogoImageView, searchButton].forEach{$0.alpha = alpha}
        
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 390)
    }
    
}


class MainPreview : PreviewProvider {
    static var previews: some View {
//        Text("Main Preview")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView : UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
