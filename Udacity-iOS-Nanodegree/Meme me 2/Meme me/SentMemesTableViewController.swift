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
    
    var memes: [Meme?] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        dvc.memeIndex = indexPath.row
        navigationController?.pushViewController(dvc, animated: true)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
