//
//  ViewController.swift
//  DB
//
//  Created by QwertY on 06.06.2023.
//

import UIKit

// MARK: - Delegate for updating UI
protocol MainViewControllerDelegate: AnyObject {
    func updateUI()
}

// MARK: - Main View Controller
class MainViewController: UIViewController {
    
    /// Main Table View
    var tableView: UITableView!
    
    /// Segmented control for switching between tables
    var segmentedControl: UISegmentedControl = {
        let items = [
            "Authors",
            "Publishers",
            "Books",
            "Students",
            "Professors",
            "Students' Cards",
            "Professors' Cards",
            "Library Employees",
            "Issued Books"
        ]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        return customSC
    }()
    
    /// View model
    var viewModel = ViewModel()

    /// On view did load method (executes only one time)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSegmentedControlAction()
        fetchDataFromDB()
        setupNavBar()
        setupDelegate()
    }
    
    /// MainViewControllerDelegate setup
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    /// Navigation bar setup
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.titleView = segmentedControl
    }
    
    /// Add row action
    @objc private func addAction() {
        guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        let alert = viewModel.getInputView(for: tableType)
        self.present(alert, animated: true) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    /// Table view setup
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    /// Add action for segmented control
    private func addSegmentedControlAction() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    /// Segmented control value chaging action
    @objc private func segmentedControlValueChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Fetch data from data base
    private func fetchDataFromDB() {
        viewModel.dbService.getData { result in
            switch result {
            case .success(let success):
                self.viewModel = success
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

// MARK: Main View Controller Delegate
extension MainViewController: MainViewControllerDelegate {
    /// Update UI
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: Table View Delegate & Data Source
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    /// Number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return 0 }
        return viewModel.getCount(for: tableType)
    }
    
    /// Cell for rows in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return cell }
        var text = ""
        var secondaryText = ""
        switch tableType {
        case .books:
            let book = viewModel.books[indexPath.row]
            text = book.title
        case .students:
            let student = viewModel.students[indexPath.row]
            text = student.firstName + " " + student.lastName
        case .professors:
            let professor = viewModel.professors[indexPath.row]
            text = professor.firstName + " " + professor.lastName
        case .authors:
            let author = viewModel.authors[indexPath.row]
            text = author.firstName + " " + author.lastName
        case .publishers:
            let publisher = viewModel.publishers[indexPath.row]
            text = publisher.name + ", " + publisher.address
        case .studentCards:
            let card = viewModel.studentCards[indexPath.row]
            text = "Issue date: \(card.issuedDate), expiration date: \(card.issuedDate)"
            secondaryText = "Student ID: \(card.studentId)"
        case .professorCards:
            let card = viewModel.professorCards[indexPath.row]
            text = "Issue date: \(card.issuedDate), expiration date: \(card.issuedDate)"
            secondaryText = "Professor ID: \(card.professorId)"
        case .libraryEmployees:
            let employee = viewModel.libraryEmployees[indexPath.row]
            text = employee.firstName + " " + employee.lastName
        case .issuedBooks:
            let issue = viewModel.issuedBooks[indexPath.row]
            guard let bookId = issue.bookId else { return cell }
            text = "Book ID: \(bookId), "
            
            text += "issue date: \(issue.issuedDate), return date: \(issue.returnDate)"
            
            if let studentCardId = issue.studentCardId {
                secondaryText = "Student Card ID: \(studentCardId)"
            }
            
            if let professorCardId = issue.professorCardId {
                secondaryText = "Professor card ID: \(professorCardId)"
            }
            
            secondaryText += ", librarian ID: \(issue.issuedById)"
        }
        cell.textLabel?.text = "\(indexPath.row + 1). " + text
        cell.detailTextLabel?.text = secondaryText
        return cell
    }
    
    /// Title for section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return nil }
        let title = viewModel.getTitle(for: tableType)
        return title
    }
    
    /// Rows selection action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        let alert = viewModel.getEditingAlert(for: tableType, at: indexPath)
        self.present(alert, animated: true) {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    /// Rows deletion action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let tableType = TableType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
            viewModel.deleteItem(from: tableType, for: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
