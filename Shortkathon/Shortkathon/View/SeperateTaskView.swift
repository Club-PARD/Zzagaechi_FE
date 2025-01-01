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
    
//    @objc private func plusAction(){
//        task.append("")
//        print(task)
//        seperateTaskTableView.reloadData()
//        updateViewHeight()
//        
//    }
    
    @objc private func plusAction() {
        task.append("")
        print(task)
        seperateTaskTableView.reloadData()
        updateViewHeight()
        notifyContentChange()
    }
    
    
    
}


//MARK: - TableView Extension
//extension SeperateTaskView : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return task.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdTableCell", for: indexPath) as? SeperateTaskViewTableCell else {
//            
//            return UITableViewCell()
//        }
//        
//        cell.taskTextField.text = task[indexPath.row]
//        cell.taskTextField.tag = indexPath.row
//        cell.taskTextField.delegate = self
//        
//        // 셀과 텍스트필드의 사용자 상호작용 활성화
//        cell.isUserInteractionEnabled = true
//        cell.taskTextField.isUserInteractionEnabled = true
//        
//        return cell
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        updateHeight()
//    }
//}
//
//
////MARK: - textField extension
//extension SeperateTaskView : UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 텍스트 변경될 때마다 호출
//        let currentText = textField.text ?? ""
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        task[textField.tag] = updatedText
//        notifyContentChange()
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        task[textField.tag] = textField.text ?? ""
//        notifyContentChange()
//    }
//
//   
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
//    
//    //textFiled 편집되었을떄 호출
////
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // 텍스트필드 편집 시작할 때 호출
//        print("텍스트필드 편집 시작")
//    }
//    
//
////    
//    // Enter 눌렀을때 return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 57
//    }
//    
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    // 스와이프 스타일 설정
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "삭제"
//    }
//}
//




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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if task.isEmpty {
                task.append("")
                tableView.reloadData()
            }
            updateViewHeight()
            notifyContentChange()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
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
