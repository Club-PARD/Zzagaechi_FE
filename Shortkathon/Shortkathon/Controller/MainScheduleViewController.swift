import UIKit

struct Task {
    let text: String
    let startTime: Date
    let endTime: Date
    var isCompleted: Bool
    let isDetailed: Bool
}

class MainScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {

    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var tasks: [Task] = []
    private var dragHandleView: UIView!
    private var completionLabel: UILabel!
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        view.layer.cornerRadius = 20
        configureDragHandle()
        configureTitleLabel()
        configureTableView()
        setConstraints()
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    private func configureDragHandle() {
        dragHandleView = UIView()
        dragHandleView.backgroundColor = .lightGray
        dragHandleView.layer.cornerRadius = 2.5
        dragHandleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dragHandleView)
    }

    private func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "오늘 할 일"
        titleLabel.font = UIFont(name: "Pretendard-Regular", size: 35)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        completionLabel = UILabel()
//      completionLabel.font = UIFont.systemFont(ofSize: 15)
        completionLabel.font = UIFont(name: "Pretendard-Regular", size: 15)

        completionLabel.textColor = .white
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        completionLabel.textAlignment = .right
        view.addSubview(completionLabel)
        updateCompletionLabel()
    }

    private func configureTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        

        tableView.register(TaskCellController.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 4
        view.addSubview(tableView)

        tableView.backgroundColor = .clear
        tableView.dragInteractionEnabled = true
        
        tableView.backgroundView = nil
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            dragHandleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dragHandleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragHandleView.widthAnchor.constraint(equalToConstant: 50),
            dragHandleView.heightAnchor.constraint(equalToConstant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: dragHandleView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            completionLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            completionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCellController else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.section]
        cell.configure(with: task.text, startTime: task.startTime, endTime: task.endTime, isDetailed: task.isDetailed)
        cell.isTaskCompleted = task.isCompleted
        cell.layer.cornerRadius = 22
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 4
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    // MARK: - UITableViewDragDelegate
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.section]
        let itemProvider = NSItemProvider(object: task.text as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = task
        return [dragItem]
    }

    // MARK: - UITableViewDropDelegate
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .forbidden)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            tableView.performBatchUpdates({
                let task = tasks.remove(at: sourceIndexPath.section)
                tasks.insert(task, at: destinationIndexPath.section)
                
                let fromIndexSet = IndexSet(integer: sourceIndexPath.section)
                let toIndexSet = IndexSet(integer: destinationIndexPath.section)
                
                tableView.deleteSections(fromIndexSet, with: .automatic)
                tableView.insertSections(toIndexSet, with: .automatic)
            })
            
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCellController {
            tasks[indexPath.section].isCompleted.toggle()
            cell.isTaskCompleted = tasks[indexPath.section].isCompleted
            updateCompletionLabel()
        }
    }
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }

    private func updateCompletionLabel() {
        let completedCount = tasks.filter { $0.isCompleted }.count
        let totalCount = tasks.count
        completionLabel.text = "\(completedCount)/\(totalCount)개"
    }

}

extension MainScheduleViewController: AddScheduleModalDelegate {
    func didAddTask(_ task: String, startTime: Date, endTime: Date, isDetailed: Bool) {
        tasks.append(Task(text: task, startTime: startTime, endTime: endTime, isCompleted: false, isDetailed: isDetailed))
        tableView.reloadData()
        updateCompletionLabel()
    }
}
