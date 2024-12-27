import UIKit


class SeperateTaskView : UIView {
    //MARK: - property
    var task : [String] = [""]
    
    var viewHeightConstraint : NSLayoutConstraint?
    private let cellHeight: CGFloat = 57  // 셀 하나의 높이
    private let cellSpacing: CGFloat = 12  // 셀 사이 간격
    private let topPadding: CGFloat = 18  // 상단 여백
    private let tableViewTopPadding: CGFloat = 21  // 테이블뷰 상단 여백
    private let bottomPadding: CGFloat = 6.5  // 하단 여백
    
    
    let seperateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size:   20)
        label.text = "세분화"
        return label
    }()
    
    let questionButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "QuestionImage"), for: .normal)
        return button
    }()
    
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
    
    let tipImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Tips")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isHidden = true
        return image
    }()
    
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTable()
        setUI()
        tipButtonAction()
        
        plusTaskButton.addTarget(self, action:  #selector(plusAction), for: .touchUpInside)
        seperateTaskTableView.dragDelegate = self
        seperateTaskTableView.dragInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - function
    func setUI(){
        [seperateLabel,questionButton,seperateTaskTableView,plusTaskButton,tipImage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            seperateLabel.topAnchor.constraint(equalTo: self.topAnchor ,constant: 18),
            seperateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 19),
            
            questionButton.topAnchor.constraint(equalTo: self.topAnchor ,constant: 18),
            questionButton.leadingAnchor.constraint(equalTo: seperateLabel.trailingAnchor, constant:   1),
            questionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -254),
            
            tipImage.leadingAnchor.constraint(equalTo: questionButton.trailingAnchor),
            tipImage.bottomAnchor.constraint(equalTo: questionButton.topAnchor, constant: 2),
            tipImage.widthAnchor.constraint(equalToConstant: 191),
            tipImage.heightAnchor.constraint(equalToConstant: 40),
            
            seperateTaskTableView.topAnchor.constraint(equalTo: seperateLabel.bottomAnchor , constant: 21),
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
    
    func tipButtonAction() {
        questionButton.addTarget(self, action: #selector(questionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    //view의 높이 계산
    private func calculateViewHeight() -> CGFloat {
        let tableViewHeight = calculateTableViewHeight()
        let totalHeight = topPadding + seperateLabel.frame.height + tableViewTopPadding + tableViewHeight + plusTaskButton.frame.height + bottomPadding
        print("seperateTaskView 높이 : \(totalHeight)")
        return max(totalHeight, 270)
    }
    
    //tableview 높이 계산
    private func calculateTableViewHeight() -> CGFloat {
        let totalCellHeight = CGFloat(task.count) * cellHeight
        let totalSpacingHeight = CGFloat(max(0, task.count - 1)) * cellSpacing
        return totalCellHeight + totalSpacingHeight
    }
    
    // 높이 업데이트 함수
    private func updateViewHeight() {
            viewHeightConstraint?.constant = calculateViewHeight()
            
            UIView.animate(withDuration: 0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
    
    @objc private func questionButtonTapped() {
        tipImage.isHidden = false
    }
    
    @objc private func handleBackgroundTap() {
        tipImage.isHidden = true
        print(task)
        self.endEditing(true)
    }
    
    @objc private func plusAction(){
        task.append("")
        print(task)
        seperateTaskTableView.reloadData()
        updateViewHeight()

    }
}


//MARK: - TableView Extension
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
        
        // 셀과 텍스트필드의 사용자 상호작용 활성화
        cell.isUserInteractionEnabled = true
        cell.taskTextField.isUserInteractionEnabled = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}


//MARK: - textField extension
extension SeperateTaskView : UITextFieldDelegate {
    //textFiled 편집되었을떄 호출
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트필드 편집 시작할 때 호출
        print("텍스트필드 편집 시작")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        task[textField.tag] = textField.text ?? ""
    }
    
    // Enter 눌렀을때 return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 스와이프 스타일 설정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 삭제 액션 처리
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 데이터 소스에서 항목 삭제
            task.remove(at: indexPath.row)
            
            // TableView에서 행 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // task 배열이 비어있으면 빈 문자열 추가
            if task.isEmpty {
                task.append("")
                tableView.reloadData()
            }
            updateViewHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}


extension SeperateTaskView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: task[indexPath.row] as NSString))
        // indexPath 정보를 저장하여 나중에 삭제할 때 사용
        dragItem.localObject = (task[indexPath.row], indexPath)
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        // 드래그가 성공적으로 완료되었을 때만 삭제
        if session.items.count > 0,
           let firstItem = session.items.first,
           let (_, indexPath) = firstItem.localObject as? (String, IndexPath) {
            // 데이터 소스에서 항목 삭제
            task.remove(at: indexPath.row)
            
            // 배열이 비어있으면 빈 문자열 추가
            if task.isEmpty {
                task.append("")
            }
            
            // TableView 업데이트
            tableView.reloadData()
            updateViewHeight()
        }
    }
}
