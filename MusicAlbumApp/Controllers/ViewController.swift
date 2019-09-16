import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumDescriptionLabel: UILabel!
    
    var albums = [AlbumEntity]()
    
    private var albumsCollectionView = AlbumsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        requstToDB()
        setupViews()
    }
    
    func requstToDB() {
        let fetchRequest: NSFetchRequest<AlbumEntity> = AlbumEntity.fetchRequest()
        do {
            albums = try PersistenceService.context.fetch(fetchRequest)
            
        }catch let err{
            print(err.localizedDescription)
        }
        albumsCollectionView.albums = albums
    }
    
    func setupViews() {
        view.addSubview(albumsCollectionView)
        albumsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        albumsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        albumsCollectionView.topAnchor.constraint(equalTo:
            albumView.bottomAnchor, constant: 10).isActive = true
        albumsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    
}


extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text{
            if text != "" {
                let substringArray = findSubstrings(text: text)
                requestToServer(band: substringArray[0], album: substringArray[1])
            }
        }
        
    }
    
    
    func findSubstrings(text: String) -> [String] {
        let pattern = "(\\w+\\s?\\w+)\\s?\\S?\\s?(\\w+\\s?\\w+)"
        
        let regex = try! NSRegularExpression(pattern: pattern)
        let result = regex.matches(in:text, range:NSMakeRange(0, text.utf16.count))
        let bandNameGroup = result[0].range(at: 1)
        let albumNameGroup = result[0].range(at: 2)
        let bandNameStartIndex = text.index(text.startIndex, offsetBy: bandNameGroup.length-1)
        
        let albumNameStartIndex = text.index(text.endIndex, offsetBy: -albumNameGroup.length)
        
        let bandName = String(text[...bandNameStartIndex]).replacingOccurrences(of: " ", with: "%20")
        let albumName = String(text[albumNameStartIndex...]).replacingOccurrences(of: " ", with: "%20")
        return [bandName, albumName]
    }
    
    func generateImage(albumStringUrl: String) -> UIImage{
        do{
            guard let url = URL(string: albumStringUrl) else { return UIImage() }
            let data  = try Data(contentsOf: url)
            guard let image = UIImage(data: data) else { return UIImage() }
            return image
        }catch let err {
            print(err.localizedDescription)
        }
        return UIImage()
    }
    
    func requestToServer(band: String, album: String) {
        let urlString = "http://theaudiodb.com/api/v1/json/1/searchalbum.php?s=\(band)&a=\(album)"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
                do {
                    guard let data = data else { return }
                    let json = try JSONDecoder().decode(Album.self, from: data).album[0]
                    let albumEntity = AlbumEntity(context: PersistenceService.context)
                    let url = URL(string: json.strAlbumThumb!)
                    let imageData  = try Data(contentsOf: url!)
                    albumEntity.thumbData = imageData as NSData
                    albumEntity.title = json.strAlbumStripped
                    albumEntity.albumDescription = json.strDescriptionEN
                    self.albums.append(albumEntity)
                    PersistenceService.saveContext()
                    self.albumsCollectionView.albums.append(albumEntity)
                    DispatchQueue.main.async {
                        if let albumImageUrl = json.strAlbumThumb {
                            self.albumImageView.image = self.generateImage(albumStringUrl: albumImageUrl)
                            self.albumTitleLabel.text = json.strAlbumStripped
                            self.albumDescriptionLabel.text = json.strDescriptionEN
                        }
                        self.albumsCollectionView.reloadData()
                    }
                    
                }catch let error {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
}
