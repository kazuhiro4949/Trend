//
//  MenuViewController.swift
//  YoutubeNews
//
//  Created by Kazuhiro Hayashi on 1/2/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewController(viewController: MenuViewController, didSelect language: Language, at index: Int)
}


class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var stubCell: MenuViewCell?
    
    var selectedIndex: Int = 0
    
    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedManager.sharedInstance.fetch { [weak self] (feeds) in
            self?.collectionView.reloadData()
        }
        let nib = UINib(nibName: "MenuViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "MenuViewCell")
        stubCell = nib.instantiateWithOwner(self, options: nil)[0] as? MenuViewCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedManager.sharedInstance.feeds.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuViewCell", forIndexPath: indexPath) as! MenuViewCell
        let active = (indexPath.row == selectedIndex)
        cell.configure(FeedManager.sharedInstance.feeds[indexPath.row].language.displayName, active: active)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let cell = stubCell {
            cell.configure(FeedManager.sharedInstance.feeds[indexPath.row].language.displayName, active: false)
            cell.layoutIfNeeded()
            var cellSize = UILayoutFittingCompressedSize
            cellSize.height = 44
            let size = cell.contentView.systemLayoutSizeFittingSize(cellSize)
            return size
        } else {
            return CGSizeMake(100, 44)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        focusCell(indexPath)
        let language = FeedManager.sharedInstance.feeds[indexPath.row].language
        delegate?.menuViewController(self, didSelect: language, at: indexPath.row)
    }
    
    
    func selectMenu(at index: Int, animated: Bool) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        focusCell(indexPath)
        
    }
    
    func focusCell(indexPath: NSIndexPath) {
        if let previousCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: selectedIndex, inSection: 0)) as? MenuViewCell {
            previousCell.focusCell(false, animated: true)
        }
        
        if let nextCell = collectionView.cellForItemAtIndexPath(indexPath) as? MenuViewCell {
            nextCell.focusCell(true, animated: true)
            collectionView.setContentOffset(nextCell.frame.origin, animated: true)
        }
        selectedIndex = indexPath.row
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}
