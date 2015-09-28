//
//  SentMemesTableViewController.swift
//  Meme me 2
//
//  Created by Tom Lai on 9/28/15.
//  Copyright © 2015 Lai. All rights reserved.
//

import UIKit
private let reuseIdentifier = "SentMemesTableViewCell"
class SentMemesTableViewController: UITableViewController {
    
    private let rowHeight : CGFloat = 88.0
    
    var memes: [Meme?]  = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesTableViewCell
        
        let meme = memes[indexPath.row]!
        cell.memeImageView.image = meme.memedImage
        cell.title.text = meme.topText!.isEmpty ? "No Title" : meme.topText
        cell.subtitle.text = meme.bottomText!.isEmpty ? "No Subtitle" : meme.bottomText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get DetailVC
        let dvc = storyboard?.instantiateViewControllerWithIdentifier("MemesViewerViewController") as! MemesViewerViewController
        let meme = memes[indexPath.row]!
        dvc.image = meme.memedImage
        dvc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(dvc, animated: true)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
