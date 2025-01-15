class YourPollViewController: UIViewController {
    // Your existing poll-related UI elements
    private var pollTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Your poll question here"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
    }
    
    @objc private func showSettings() {
        let settingsVC = TextSettingsViewController()
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - TextSettingsDelegate
extension YourPollViewController: TextSettingsDelegate {
    func didUpdateFontSize(_ size: CGFloat) {
        pollTextLabel.font = UIFont(name: pollTextLabel.font.fontName, size: size)
    }
    
    func didUpdateFontFamily(_ fontFamily: String) {
        if let newFont = UIFont(name: fontFamily, size: pollTextLabel.font.pointSize) {
            pollTextLabel.font = newFont
        }
    }
    
    func didUpdateTextColor(_ color: UIColor) {
        pollTextLabel.textColor = color
    }
} 