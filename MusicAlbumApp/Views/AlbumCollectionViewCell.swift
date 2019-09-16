import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "AlbumCollectionViewCell"
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(albumImageView)
        addSubview(albumTitleLabel)
        addSubview(albumDescriptionLabel)
        
        albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: bounds.height*0.5).isActive = true
        
        albumTitleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 10).isActive = true
        albumTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor ).isActive = true
        albumTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        albumTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        albumDescriptionLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: 5).isActive = true
        albumDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        albumDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        albumDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
