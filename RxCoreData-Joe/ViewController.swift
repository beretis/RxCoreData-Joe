//
//  ViewController.swift
//  RxCoreData-Joe
//
//  Created by Jozef Matus on 26/04/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class ViewController: UIViewController {
    
    var button = UIButton(frame: CGRect(origin: CGPoint.init(x: 50, y: 50), size: CGSize(width: 230, height: 30)))
    var button2 = UIButton(frame: CGRect(origin: CGPoint.init(x: 50, y: 150), size: CGSize(width: 230, height: 30)))
    var button3 = UIButton(frame: CGRect(origin: CGPoint.init(x: 50, y: 200), size: CGSize(width: 230, height: 30)))

    var mainThing: MainEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("add random parrent", for: .normal)
        button2.setTitle("add random childs", for: .normal)
        button3.setTitle("add random sdlfkjadkslf", for: .normal)
        button.backgroundColor = UIColor.black
        button2.backgroundColor = UIColor.black
        button3.backgroundColor = UIColor.black

        self.view.addSubview(button)
        self.view.addSubview(button2)
        self.view.addSubview(button3)

        self.setupRx()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupRx() {
        self.button.rx.tap.do(onNext: {
            self.addRandomParrent()
        }).subscribe()
        
        self.button2.rx.tap.do(onNext: {
            let pes = self.gimmeRandomArrayOfChildsA()
            guard var mainThing = self.mainThing else {
                return
            }
            mainThing.childsa.setValue(pes)
            try coreDataStack.managedObjectContext.rx.update(mainThing)
        }).subscribe()
        
        self.button3.rx.tap.flatMap { _ in
            return coreDataStack.managedObjectContext.rx.entities(MainEntity.self, predicate: nil, sortDescriptors: nil, limit: nil)
            }.subscribe(onNext: { (entities) in
                print(entities)
            })
        
        coreDataStack.managedObjectContext.rx.entities(MainEntity.self, predicate: nil, sortDescriptors: nil, limit: nil).subscribe(onNext: { (entities) in
            print(entities)
        })
        
    }
    
    
    
    func addRandomParrent() {
        let id = String(arc4random_uniform(6000000))
        var parent = MainEntity(id: id, value: id)
        self.mainThing = parent
        try? coreDataStack.managedObjectContext.rx.update(parent)
    }
    
    func gimmeRandomArrayOfChildsA() -> [ChildA] {
        var childsA: [ChildA] = []
        let howMany = Int(arc4random_uniform(14))
        for _ in 0 ... howMany {
            let id = String(arc4random_uniform(6000000))
            childsA.append(ChildA(id: id, value: id))
        }
        return childsA
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

