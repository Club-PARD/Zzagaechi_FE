import UIKit

protocol AddButtonModalViewControllerDelegate: AnyObject {
    func didAddEvent(name: String, startDate: Date, endDate: Date, isDetailed: Bool)
}

class AddButtonModalViewController: UIViewController {
    
    weak var delegate: AddButtonModalViewControllerDelegate?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "일정 이름"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let detailToggleSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // 스택뷰로 UI 구성
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            createToggleView(),
            createLabel("시작일"), startDatePicker,
            createLabel("종료일"), endDatePicker
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        // 버튼 스택뷰 생성
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("추가", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(addButton)
        
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createToggleView() -> UIStackView {
        let toggleLabel = createLabel("세분화")
        detailToggleSwitch.isOn = true
        detailToggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged), for: .valueChanged)
        let toggleView = UIStackView(arrangedSubviews: [toggleLabel, detailToggleSwitch])
        toggleView.axis = .horizontal
        toggleView.spacing = 10
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        return toggleView
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        if detailToggleSwitch.isOn {
            // 세분화가 켜져있을 때는 기존 방식대로
            delegate?.didAddEvent(
                name: title,
                startDate: startDatePicker.date,
                endDate: endDatePicker.date,
                isDetailed: true
            )
        } else {
            // 세분화가 꺼져있을 때는 종료일을 시작일과 종료일로 설정
            let selectedDate = endDatePicker.date
            delegate?.didAddEvent(
                name: title,
                startDate: selectedDate,
                endDate: selectedDate,
                isDetailed: false
            )
        }
        dismiss(animated: true)
    }
    
    private func setupKeyboardDismiss() {
        // 뷰에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func toggleSwitchChanged(_ sender: UISwitch) {
        startDatePicker.isEnabled = sender.isOn
        startDatePicker.alpha = sender.isOn ? 1.0 : 0.5
    }
}
