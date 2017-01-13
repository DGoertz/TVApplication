import UIKit
import Foundation
import PlaygroundSupport

import Foundation

let pup: Dog = Dog()
let manager: EntityManager = EntityManager.sharedInstance
manager.register(entity: pup)

let size: CGSize = CGSize(width: 100, height: 100)
PlaygroundPage.current.needsIndefiniteExecution = true
if let backingImage: UIImage = PlotFunctions.createBlankImage(ofSize: size)
{
    for nextID in manager.entites.keys
    {
        if let nextEntity = manager.entites[nextID]
        {
            var image: UIImage? = nextEntity.render(onto: backingImage)
            let iView: UIImageView = UIImageView(image: image)
            iView.backgroundColor = UIColor.blue
            PlaygroundPage.current.liveView = iView
        }
    }
}

