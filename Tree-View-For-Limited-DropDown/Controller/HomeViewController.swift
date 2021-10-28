//
//  ViewController.swift
//  Tree-View-For-Limited-DropDown
//
//  Created by Mac on 28/10/21.
//

import UIKit

enum CellType {
    case RadioButton
    case CheckBox
}

struct TechGroup {
    let id: Int
    let title: String
    let subGroup: [TechGroup]?
}

class HomeViewController: UIViewController {
    
    // KJ Tree instances -------------------------
    private var parentTree:[Parent] = []
    private var ingredientTreeInstance: KJTree = KJTree()
    private var childrenForParent = [Child]()
    
    // Here Parent is Android Group
    let techGroup: [TechGroup] = [TechGroup(id: 0,
                                            title: "Android Group",
                                            subGroup: [TechGroup(id: 1,
                                                                 title: "Meetings",
                                                                 subGroup: [TechGroup(id: 2,
                                                                                      title: "Agenda",
                                                                                      subGroup: nil),
                                                                            TechGroup(id: 3,
                                                                                      title: "Goal",
                                                                                      subGroup: nil)]),
                                                       TechGroup(id: 4,
                                                                 title: "Attendance",
                                                                 subGroup: [TechGroup(id: 5,
                                                                                      title: "Jan",
                                                                                      subGroup: nil),
                                                                            TechGroup(id: 6,
                                                                                      title: "Feb",
                                                                                      subGroup: nil)]),
                                                       TechGroup(id: 7,
                                                                 title: "Experts",
                                                                 subGroup: [TechGroup(id: 8,
                                                                                      title: "Shan",
                                                                                      subGroup: nil),
                                                                            TechGroup(id: 9,
                                                                                      title: "Murugan",
                                                                                      subGroup: nil),
                                                                            TechGroup(id: 10,
                                                                                      title: "Kiruba",
                                                                                      subGroup: nil),
                                                                            TechGroup(id: 11,
                                                                                      title: "Mohan",
                                                                                      subGroup: nil)])])]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingredientCellNib = UINib(nibName: "IngredientTableViewCell", bundle: nil)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: "IngredientTableViewCell")
        configureChildren(for: &parentTree)
        self.ingredientTreeInstance = KJTree(Parents: self.parentTree)
        tableView.reloadData()
    }
    
    private func configureChildren(for parent: inout [Parent]) {
        
        for mainGroupItem in techGroup {
            let parentNew = Parent(expanded: true) {
                addChildrenRecursively(subGroup: mainGroupItem, childVar: &childrenForParent)
                return childrenForParent
            }
            parent.append(parentNew)
            childrenForParent.removeAll()
        }
    }
    func addChildrenRecursively(subGroup: TechGroup, childVar: inout [Child]) {
        subGroup.subGroup?.forEach {sub in
            childVar.append(Child(subChilds: {
                var subChild = [Child]()
                addChildrenRecursively(subGroup: sub, childVar: &subChild)
                return subChild
            }))
        }
    }
    
    func getDataForTechGroup(from index: String) -> TechGroup? {
        if index.isEmpty { return nil }
        let indexList: [Int] = index.components(separatedBy: ".").map {Int($0)!}
        var requiredTechGroup: TechGroup?
        indexList.forEach { index in
            if let tg = requiredTechGroup {
                requiredTechGroup = tg.subGroup?[index]
            } else {
                requiredTechGroup = techGroup[index]
            }
            
        }
        return requiredTechGroup
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = ingredientTreeInstance.tableView(tableView, numberOfRowsInSection: section)
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = ingredientTreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        let tableviewcell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell") as! IngredientTableViewCell
        guard let items = getDataForTechGroup(from: node.index) else { return UITableViewCell() }
        let cellType: CellType = .RadioButton
        tableviewcell.configureView(state: node.state, ingredient: items.title, price: "10", spacing: indexTuples.count, type: cellType)
        return tableviewcell
    }
    
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNode = ingredientTreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        guard let items = getDataForTechGroup(from: selectedNode.index) else { return }
        print(items.title)
        _ = ingredientTreeInstance.tableView(tableView, didSelectRowAt: indexPath)
    }
}
