import UIKit

struct Task {
    let text: String
    let startTime: Date
    let endTime: Date
    var isCompleted: Bool
}

class MainScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {

    private var titleLabel: UILabel!
    private var AddScheduleButton: UIButton!
    private var titleAndButtonStackView: UIStackView!
    
    private var tableView: UITableView!
    private var tasks: [Task] = []
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        view.layer.cornerRadius = 20
        configureTitleAndButtonStackView()
        configureTableView()
        setConstraints()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    private func configureTitleAndButtonStackView() {
        titleAndButtonStackView = UIStackView()
        titleAndButtonStackView.axis = .horizontal
        titleAndButtonStackView.alignment = .center
        titleAndButtonStackView.spacing = 10
        titleAndButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        titleAndButtonStackView.layer.cornerRadius = 20
        titleAndButtonStackView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        view.addSubview(titleAndButtonStackView)
        
        titleLabel = UILabel()
        titleLabel.text = "오늘 할 일"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        AddScheduleButton = UIButton(type: .custom)
        if let buttonImage = UIImage(named: "mainPlus") {
            AddScheduleButton.setImage(buttonImage, for: .normal)
        }
        AddScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        AddScheduleButton.contentMode = .scaleAspectFit
        AddScheduleButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        AddScheduleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleAndButtonStackView.addArrangedSubview(titleLabel)
        titleAndButtonStackView.addArrangedSubview(AddScheduleButton)
        
        AddScheduleButton.addTarget(self, action: #selector(didTapAddScheduleButton), for: .touchUpInside)
    }

    private func configureTableView() {
        tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
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

    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleAndButtonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleAndButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleAndButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleAndButtonStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        cell.configure(with: task.text, startTime: task.startTime, endTime: task.endTime)
        cell.isTaskCompleted = task.isCompleted
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

    @objc private func didTapAddScheduleButton() {
        let modalVC = AddScheduleModalViewController()
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
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
        }
    }
}

extension MainScheduleViewController: AddScheduleModalDelegate {
    func didAddTask(_ task: String, startTime: Date, endTime: Date) {
        tasks.append(Task(text: task, startTime: startTime, endTime: endTime, isCompleted: false))
        tableView.reloadData()
    }
}
