import UIKit


class SeperateTaskView : UIView {
    //MARK: - property
    var task : [String] = [""]
    weak var delegate: SeperateTaskViewDelegate?
    
    var viewHeightConstraint : NSLayoutConstraint?
    
    private let cellHeight: CGFloat = 57  // 셀 하나의 높이
    private let cellSpacing: CGFloat = 12  // 셀 사이 간격
    private let topPadding: CGFloat = 18  // 상단 여백
    private let tableViewTopPadding: CGFloat = 21  // 테이블뷰 상단 여백
    private let bottomPadding: CGFloat = 6.5  // 하단 여백
    
    
    
    
    let seperateTaskTableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.allowsSelection = false
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    let plusTaskButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlusImage"), for: .normal)
        return button
    }()
    
    
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTable()
        setUI()
        addInitialCells()
        touchAction()
        plusTaskButton.addTarget(self, action:  #selector(plusAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [seperateTaskTableView,plusTaskButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            seperateTaskTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor , constant: 21),
            seperateTaskTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            seperateTaskTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            
            plusTaskButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusTaskButton.topAnchor.constraint(equalTo: seperateTaskTableView.bottomAnchor, constant: 6.5 ),
            plusTaskButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -10),
        ])
    }
    
    func setTable(){
        seperateTaskTableView.delegate = self
        seperateTaskTableView.dataSource = self
        seperateTaskTableView.register(SeperateTaskViewTableCell.self, forCellReuseIdentifier: "ThirdTableCell")
        seperateTaskTableView.isUserInteractionEnabled = true
        
    }
    
    private func addInitialCells() {
            // 3개의 빈 셀 추가
            for _ in 0..<2 {
                task.append("")  // 빈 문자열로 초기화
                let indexPath = IndexPath(row: task.count - 1, section: 0)
                seperateTaskTableView.insertRows(at: [indexPath], with: .none)
            }
            
            // 테이블뷰 높이 업데이트
            updateViewHeight()
        }
        
    func touchAction() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func notifyContentChange() {
        // 테이블뷰에 내용이 있는지 확인
        let hasContent = !task.contains{ $0.isEmpty}
        print("Tasks: \(task)")
         print("Has content: \(hasContent)")
        delegate?.taskContentDidChange(hasContent: hasContent)
    }
    
    // 셀이 추가되거나 삭제될 때마다 호출
    func updateContent() {
        notifyContentChange()
    }
    //view의 높이 계산
    private func calculateViewHeight() -> CGFloat {
        let tableViewHeight = calculateTableViewHeight()
        let totalHeight = topPadding + tableViewTopPadding + tableViewHeight + plusTaskButton.frame.height + bottomPadding
        print("seperateTaskView 높이 : \(totalHeight)")
        return max(totalHeight, 270)
    }
    
    //tableview 높이 계산
    private func calculateTableViewHeight() -> CGFloat {
        let totalCellHeight = CGFloat(task.count) * cellHeight
        let totalSpacingHeight = CGFloat(max(0, task.count - 1)) * cellSpacing
        return totalCellHeight + totalSpacingHeight
    }
    
    
    func updateHeight() {
        let tableHeight = seperateTaskTableView.contentSize.height
        
        let totalHeight = tableHeight // 버튼 높이(44) + 여백(10) 포함
        viewHeightConstraint?.constant = totalHeight
        // 상위 스크롤뷰에 레이아웃 업데이트 알림
        superview?.layoutIfNeeded()
    }
    
    
    
    // 높이 업데이트 함수
    private func updateViewHeight() {
        viewHeightConstraint?.constant = calculateViewHeight()
        
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    
    @objc private func handleBackgroundTap() {
        print(task)
        self.endEditing(true)
    }

    
    @objc private func plusAction() {
        task.append("")
        print(task)
        seperateTaskTableView.reloadData()
        updateViewHeight()
        notifyContentChange()
    }
    
    
    
}

extension SeperateTaskView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableCell", for: indexPath) as? SeperateTaskViewTableCell else {
            return UITableViewCell()
        }
        
        cell.taskTextField.text = task[indexPath.row]
        cell.taskTextField.tag = indexPath.row
        cell.taskTextField.delegate = self
        
        switch indexPath.row {
            case 0:
                cell.taskTextField.placeholder = "어떤 작업부터 시작해야 할지 적어볼까요?"
            case 1:
                cell.taskTextField.placeholder = "예)자료 찾기, 초안 작성하기, 수정하기 등"
            case 2:
                cell.taskTextField.placeholder = "한 번에 하나씩 실행할 수 있는 크기로 나눠보세요"
            default:
                cell.taskTextField.placeholder = "새로운 작업을 입력하세요"
            }
        
        
        
        cell.isUserInteractionEnabled = true
        cell.taskTextField.isUserInteractionEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            self.task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if self.task.isEmpty {
                self.task.append("")
                tableView.reloadData()
            }
            
            self.updateViewHeight()
            self.notifyContentChange()
            completion(true)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 0.9986872077, green: 0.3591775596, blue: 0.006945624482, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            task.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            
//            if task.isEmpty {
//                task.append("")
//                tableView.reloadData()
//            }
//            updateViewHeight()
//            notifyContentChange()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "삭제"
//    }
}

// MARK: - TextField Extension
extension SeperateTaskView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        task[textField.tag] = updatedText
        notifyContentChange()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        task[textField.tag] = textField.text ?? ""
        notifyContentChange()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
