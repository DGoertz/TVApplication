import UIKit
import Foundation
import PlaygroundSupport

//let pup: Dog = Dog()
//let manager: EntityManager = EntityManager.sharedInstance
//manager.register(entity: pup)
//
//let size: CGSize = CGSize(width: 100, height: 100)
//PlaygroundPage.current.needsIndefiniteExecution = true
//if let backingImage: UIImage = PlotFunctions.createBlankImage(ofSize: size)
//{
//    for nextID in manager.getKeys()
//    {
//        if let nextEntity = manager.getEntity(fromID: nextID)
//        {
//            var image: UIImage? = nextEntity.render(onto: backingImage)
//            let iView: UIImageView = UIImageView(image: image)
//            iView.backgroundColor = UIColor.blue
//            PlaygroundPage.current.liveView = iView
//        }
//    }
//}

//let test: Vector2D = Vector2D(x: 5, y: 2)
//let trans: Matrix2D = Matrix2D.getTranslation(tx: 2, ty: 7)
//let ans = test * trans
//print("\(ans)")
for i in 0...9
{
    let dice = arc4random_uniform(2)
    print("Index: \(i) - \(dice)")
}

