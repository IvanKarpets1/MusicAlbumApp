import UIKit

class AlbumsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var albums = [AlbumEntity]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        delegate = self
        dataSource = self
        register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseId, for: indexPath) as! AlbumCollectionViewCell
        cell.albumTitleLabel.text = albums[indexPath.row].title
        cell.albumDescriptionLabel.text = albums[indexPath.row].albumDescription
        cell.albumImageView.image = generateImage(data: albums[indexPath.row].thumbData! as Data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width*0.5, height: collectionView.bounds.height)
    }
    func generateImage(data: Data) -> UIImage{
        guard let image = UIImage(data: data) else { return UIImage() }
        return image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



