//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        let url = URL(string: movie.thumbnailPath)
        cell.moviewThumnail.kf.setImage(with: url)
        
        return cell
    }
}

extension SearchViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let movie = self.movies[indexPath.item]
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: false, completion: nil)
    }
}

extension SearchViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin:CGFloat = 8
        let itemSpacing:CGFloat = 10
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2)/3
        let height = width * 10/7//7:10비율
        
        return CGSize(width: width, height: height)
    }
}

class ResultCell:UICollectionViewCell{
    @IBOutlet weak var moviewThumnail:UIImageView!
}

extension SearchViewController:UISearchBarDelegate{
    
    private func dismissKeyBoard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismissKeyBoard()
        guard let searchTerm = searchBar.text,searchTerm.isEmpty == false else{
            return
        }
        
        SearchAPI.search(searchTerm) { movies in
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
            }
        }
        
        print("----->\(searchTerm)")
    }
}
