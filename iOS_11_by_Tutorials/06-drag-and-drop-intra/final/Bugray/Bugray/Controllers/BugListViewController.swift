/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class BugListViewController: UIViewController {

  @IBOutlet private var bugCountLabel: UILabel!
  @IBOutlet private var contextLabel: UILabel!
  @IBOutlet private var collectionView: UICollectionView!

  var context: Bug.Context = .toDo

  override func viewDidLoad() {
    super.viewDidLoad()
    setBugCount()
    setContextTitle()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.dragDelegate = self
    collectionView.dropDelegate = self
  }

  private func setContextTitle() {
    let contextTitleMap: [Bug.Context: String] = [
      .toDo: "To Do",
      .inProgress: "In Progress",
      .done: "Done"
    ]
    contextLabel.text = contextTitleMap[context]
  }

  private func setBugCount() {
    bugCountLabel.text = "\(BugStore.sharedStore.bugs(for: context).count)"
  }
}

extension BugListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return BugStore.sharedStore.bugs(for: context).count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BugCell", for: indexPath) as! BugCell
    let bug = BugStore.sharedStore.bug(at: indexPath.item, in: context)
    cell.bug = bug
    return cell
  }
}

extension BugListViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 100)
  }
}

extension BugListViewController: UICollectionViewDragDelegate {

  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let dragCoordinator = BugDragCoordinator(source: context)
    session.localContext = dragCoordinator
    return [dragCoordinator.dragItemForBugAt(indexPath: indexPath)]
  }

  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
    guard let dragCoordinator = session.localContext as? BugDragCoordinator, dragCoordinator.source == context else { return [] }
    return [dragCoordinator.dragItemForBugAt(indexPath: indexPath)]
  }

  func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
    guard let dragCoordinator = session.localContext as? BugDragCoordinator,
      dragCoordinator.source == context,
      dragCoordinator.dragCompleted == true,
      dragCoordinator.isReordering == false else { return }
    collectionView.performBatchUpdates({
      collectionView.deleteItems(at: dragCoordinator.sourceIndexPaths)
    }, completion: { _ in
      self.setBugCount()
    })
  }
}

extension BugListViewController: UICollectionViewDropDelegate {

  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.localDragSession != nil ? true : false
  }

  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }

  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let dragCoordinator = coordinator.session.localDragSession?.localContext as? BugDragCoordinator else { return }
    let indexPath = coordinator.destinationIndexPath ?? IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)
    dragCoordinator.calculateDestinationIndexPaths(from: indexPath, count: coordinator.items.count)
    dragCoordinator.destination = context
    moveBugs(using: dragCoordinator, performingDropWith: coordinator)
  }

  private func moveBugs(using dragCoordinator: BugDragCoordinator, performingDropWith dropCoordinator: UICollectionViewDropCoordinator) {
    guard let destination = dragCoordinator.destination, let destinationIndexPaths = dragCoordinator.destinationIndexPaths else { return }
    let bugs = BugStore.sharedStore.deleteBugs(at: dragCoordinator.sourceIndexes, in: dragCoordinator.source)
    for (index, item) in dropCoordinator.items.enumerated() {
      let sourceIndexPath = dragCoordinator.sourceIndexPaths[index]
      let destinationIndexPath = destinationIndexPaths[index]
      collectionView.performBatchUpdates({
        BugStore.sharedStore.insert(bugs: [bugs[index]], into: destination, at: destinationIndexPath.item)
        if dragCoordinator.isReordering {
          self.collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
        } else {
          self.collectionView.insertItems(at: [destinationIndexPath])
        }
      }, completion: { _ in
        self.setBugCount()
      })
      dropCoordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }
    dragCoordinator.dragCompleted = true
  }
}
