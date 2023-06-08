//
//  Model.swift
//  DB
//
//  Created by QwertY on 07.06.2023.
//

import Foundation
import PostgresClientKit
import UIKit

// MARK: - Table Type
enum TableType: Int {
    case authors = 0, publishers, books, students, professors, studentCards, professorCards, libraryEmployees, issuedBooks
}

// MARK: - View Model
class ViewModel {
    
    // MARK: - Tables Data
    var authors = [Author]()
    var publishers = [Publisher]()
    var books = [Book]()
    var students = [Student]()
    var professors = [Professor]()
    var studentCards = [StudentCard]()
    var professorCards = [ProfessorCard]()
    var libraryEmployees = [LibraryEmployee]()
    var issuedBooks = [BookIssue]()

    // MARK: - PostgreSQL service
    var dbService = DBService.shared
    
    /// Main View Controller delegate
    weak var delegate: MainViewControllerDelegate?
    
    /// Gets number of rows in particular table
    func getCount(for tableType: TableType) -> Int {
        switch tableType {
        case .books:
            return books.count
        case .students:
            return students.count
        case .professors:
            return professors.count
        case .authors:
            return authors.count
        case .publishers:
            return publishers.count
        case .studentCards:
            return studentCards.count
        case .professorCards:
            return professorCards.count
        case .libraryEmployees:
            return libraryEmployees.count
        case .issuedBooks:
            return issuedBooks.count
        }
    }
    
    /// Gets title for particular table
    func getTitle(for tableType: TableType) -> String {
        switch tableType {
        case .authors:
            return "Authors"
        case .publishers:
            return "Publishers"
        case .books:
            return "Books"
        case .students:
            return "Students"
        case .professors:
            return "Professors"
        case .studentCards:
            return "Students' Cards"
        case .professorCards:
            return "Professors' Cards"
        case .libraryEmployees:
            return "Library Employees"
        case .issuedBooks:
            return "Issued Books"
        }
    }
    
    // MARK: - Adds rows
    func getInputView(for table: TableType) -> UIAlertController {
        let title = "Add item for " + getTitle(for: table)
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        switch table {
        case .authors:
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let author = Author(firstName: firstName, lastName: lastName)
                self?.authors.append(author)
                let query = "INSERT INTO \"Authors\" (last_name, first_name) VALUES ($1, $2)"
                DBService.shared.perfromQuery(queryText: query, parameters: [author.lastName, author.firstName])
                self?.delegate?.updateUI()
            }))
        case .publishers:
            alertController.addTextField { textField in
                textField.placeholder = "Name"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Address"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let name = textField.text else { return }
                guard let address = textField2.text else { return }
                
                let publisher = Publisher(name: name, address: address)
                self?.publishers.append(publisher)
                let query = "INSERT INTO \"Publishers\" (name, address) VALUES ($1, $2)"
                DBService.shared.perfromQuery(queryText: query, parameters: [publisher.name, publisher.address])
                self?.delegate?.updateUI()
            }))
        case .books:
            alertController.addTextField { textField in
                textField.placeholder = "Title"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Publication Year"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Available copies"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Author ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Publisher ID"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                let textField3 = alertController.textFields![3] as UITextField
                let textField4 = alertController.textFields![4] as UITextField
                
                guard let title = textField.text else { return }
                guard let publicationYear = textField1.text else { return }
                guard let numOfCopies = textField2.text else { return }
                guard let authorId = textField3.text else { return }
                guard let publisherId = textField4.text else { return }
                
                let book = Book(title: title, publisherId: Int(publisherId), authorId: Int(authorId), publicationYear: Int(publicationYear), availableCopies: Int(numOfCopies))
                self?.books.append(book)
                let query = "INSERT INTO \"Books\" (title, publication_year, available_copies, author_id, publisher_id) VALUES ($1, $2, $3, $4, $5)"
                DBService.shared.perfromQuery(queryText: query, parameters: [title, publicationYear, numOfCopies, authorId, publisherId])
                self?.delegate?.updateUI()
            }))
        case .students:
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let student = Student(firstName: firstName, lastName: lastName)
                self?.students.append(student)
                let query = "INSERT INTO \"Students\" (first_name, last_name) VALUES ($1, $2)"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName])
                self?.delegate?.updateUI()
            }))
        case .professors:
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let professor = Professor(firstName: firstName, lastName: lastName)
                self?.professors.append(professor)
                let query = "INSERT INTO \"Professors\" (first_name, last_name) VALUES ($1, $2)"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName])
                self?.delegate?.updateUI()
            }))
        case .studentCards:
            alertController.addTextField { textField in
                textField.placeholder = "Student ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Expiration Date"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let studentId = textField.text else { return }
                guard let issuedDate = textField1.text else { return }
                guard let expirationDate = textField2.text else { return }
                
                let studentCard = StudentCard(studentId: Int(studentId)!, issuedDate: PostgresDate(issuedDate)!, expirationDate: PostgresDate(expirationDate)!)
                self?.studentCards.append(studentCard)
                let query = "INSERT INTO \"StudentCards\" (student_id, issue_date, expiration_date) VALUES ($1, $2, $3)"
                DBService.shared.perfromQuery(queryText: query, parameters: [studentCard.studentId, studentCard.issuedDate, studentCard.expirationDate])
                self?.delegate?.updateUI()
            }))
        case .professorCards:
            alertController.addTextField { textField in
                textField.placeholder = "Professor ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Expiration Date"
            }

            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let professorId = textField.text else { return }
                guard let issuedDate = textField1.text else { return }
                guard let expirationDate = textField2.text else { return }
                
                let professorCard = ProfessorCard(professorId: Int(professorId)!, issuedDate: PostgresDate(issuedDate)!, expirationDate: PostgresDate(expirationDate)!)
                self?.professorCards.append(professorCard)
                let query = "INSERT INTO \"ProfessorCards\" (professor_id, issue_date, expiration_date) VALUES ($1, $2, $3)"
                DBService.shared.perfromQuery(queryText: query, parameters: [professorCard.professorId, professorCard.issuedDate, professorCard.expirationDate])
                self?.delegate?.updateUI()
            }))
        case .libraryEmployees:
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Card Number"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField1.text else { return }
                guard let cardNumber = textField2.text else { return }
                
                let librarian = LibraryEmployee(firstName: firstName, lastName: lastName, libraryCardNumber: cardNumber)
                self?.libraryEmployees.append(librarian)
                let query = "INSERT INTO \"LibraryStaff\" (first_name, last_name, library_card_number) VALUES ($1, $2, $3)"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName, cardNumber])
                self?.delegate?.updateUI()
            }))
        case .issuedBooks:
            alertController.addTextField { textField in
                textField.placeholder = "Book ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Student Card ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Professor Card ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued By ID"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Return Date"
            }
            
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                let textField3 = alertController.textFields![3] as UITextField
                let textField4 = alertController.textFields![4] as UITextField
                let textField5 = alertController.textFields![5] as UITextField
                
                guard let bookId = textField.text else { return }
                guard let studentCardId = textField1.text else { return }
                guard let professorCardId = textField2.text else { return }
                guard let issuedById = textField3.text else { return }
                guard let issuedDate = textField4.text else { return }
                guard let returnDate = textField5.text else { return }
                
                let bookIssue = BookIssue(bookId: Int(bookId) ?? 0, professorCardId: Int(professorCardId) ?? 0, studentCardId: Int(studentCardId) ?? 0, issuedById: Int(issuedById) ?? 0, issuedDate: PostgresDate(issuedDate)!, returnDate: PostgresDate(returnDate)!)
                self?.issuedBooks.append(bookIssue)
                let query = "INSERT INTO \"BookIssues\" (book_id, student_card_id, professor_card_id, issued_by_id, issue_date, return_date) VALUES ($1, $2, $3, $4, $5, $6)"
                DBService.shared.perfromQuery(queryText: query, parameters: [bookId, studentCardId, professorCardId, issuedById, issuedDate, returnDate])
                self?.delegate?.updateUI()
            }))
        }
        return alertController
    }
    
    // MARK: - Deletes rows
    func deleteItem(from table: TableType, for indexPath: IndexPath) {
        switch table {
        case .authors:
            let author = authors.remove(at: indexPath.row)
            let query = "DELETE FROM \"Authors\" WHERE author_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [author.id])
        case .publishers:
            let publisher = publishers.remove(at: indexPath.row)
            let query = "DELETE FROM \"Publishers\" WHERE publisher_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [publisher.id])
        case .books:
            let book = books.remove(at: indexPath.row)
            let query = "DELETE FROM \"Books\" WHERE book_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [book.id])
        case .students:
            let student = students.remove(at: indexPath.row)
            let query = "DELETE FROM \"Students\" WHERE student_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [student.id])
        case .professors:
            let professor = professors.remove(at: indexPath.row)
            let query = "DELETE FROM \"Professors\" WHERE professor_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [professor.id])
        case .studentCards:
            let studentCard = studentCards.remove(at: indexPath.row)
            let query = "DELETE FROM \"StudentCards\" WHERE card_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [studentCard.id])
        case .professorCards:
            let professorCard = professorCards.remove(at: indexPath.row)
            let query = "DELETE FROM \"ProfessorCards\" WHERE card_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [professorCard.id])
        case .libraryEmployees:
            let libraryEmployee = libraryEmployees.remove(at: indexPath.row)
            let query = "DELETE FROM \"LibraryStaff\" WHERE staff_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [libraryEmployee.id])
        case .issuedBooks:
            let issuedBook = issuedBooks.remove(at: indexPath.row)
            let query = "DELETE FROM \"LibraryStaff\" WHERE issue_id = $1"
            DBService.shared.perfromQuery(queryText: query, parameters: [issuedBook.id])
        }
    }
    
    // MARK: - Edits rows
    func getEditingAlert(for table: TableType, at indexPath: IndexPath) -> UIAlertController {
        let title = "Edit item in " + getTitle(for: table)
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        switch table {
        case .authors:
            let author = authors[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
                textField.text = author.firstName
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
                textField.text = author.lastName
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let editedAuthor = Author(id: author.id, firstName: firstName, lastName: lastName)
                self?.authors[indexPath.row] = editedAuthor
                
                let query = "UPDATE \"Authors\" SET last_name = $1, first_name = $2 WHERE author_id = $3"
                DBService.shared.perfromQuery(queryText: query, parameters: [editedAuthor.lastName, editedAuthor.firstName, editedAuthor.id])
                self?.delegate?.updateUI()
            }))
        case .publishers:
            let publisher = publishers[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "Name"
                textField.text = publisher.name
            }
            alertController.addTextField { textField in
                textField.placeholder = "Address"
                textField.text = publisher.address
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let name = textField.text else { return }
                guard let address = textField2.text else { return }
                
                let editedPublisher = Publisher(id: publisher.id, name: name, address: address)
                self?.publishers[indexPath.row] = editedPublisher
                let query = "UPDATE \"Publishers\" SET name = $1, address = $2 WHERE publisher_id = $3"
                DBService.shared.perfromQuery(queryText: query, parameters: [editedPublisher.name, editedPublisher.address, publisher.id])
                self?.delegate?.updateUI()
            }))
        case .books:
            let book = books[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "Title"
                textField.text = book.title
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Publication Year"
                guard let year = book.publicationYear else { return }
                textField.text = String(year)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Available copies"
                guard let copies = book.availableCopies else { return }
                textField.text = String(copies)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Author ID"
                guard let authorId = book.authorId else { return }
                textField.text = String(authorId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Publisher ID"
                guard let publisherId = book.publisherId else { return }
                textField.text = String(publisherId)
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                let textField3 = alertController.textFields![3] as UITextField
                let textField4 = alertController.textFields![4] as UITextField
                
                guard let title = textField.text else { return }
                guard let publicationYear = textField1.text else { return }
                guard let numOfCopies = textField2.text else { return }
                guard let authorId = textField3.text else { return }
                guard let publisherId = textField4.text else { return }
                
                let updatedBook = Book(id: book.id, title: title, publisherId: Int(publisherId), authorId: Int(authorId), publicationYear: Int(publicationYear), availableCopies: Int(numOfCopies))
                self?.books[indexPath.row] = updatedBook
                let query = "UPDATE \"Books\" SET title = $1, publication_year = $2, available_copies = $3, author_id = $4, publisher_id = $5 WHERE book_id = $6"
                DBService.shared.perfromQuery(queryText: query, parameters: [title, publicationYear, numOfCopies, authorId, publisherId, book.id])
                self?.delegate?.updateUI()
            }))
        case .students:
            let student = students[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
                textField.text = student.firstName
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
                textField.text = student.lastName
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let editedStudent = Student(id: student.id, firstName: firstName, lastName: lastName)
                self?.students[indexPath.row] = editedStudent
                let query = "UPDATE \"Students\" SET first_name = $1, last_name = $2 WHERE student_id = $3"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName, student.id])
                self?.delegate?.updateUI()
            }))
        case .professors:
            let professor = professors[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
                textField.text = professor.firstName
            }
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
                textField.text = professor.lastName

            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField2 = alertController.textFields![1] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField2.text else { return }
                
                let editedProfessor = Professor(id: professor.id, firstName: firstName, lastName: lastName)
                self?.professors[indexPath.row] = editedProfessor
                let query = "UPDATE \"Professors\" SET first_name = $1, last_name = $2 WHERE professor_id = $3"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName, professor.id])
                self?.delegate?.updateUI()
            }))
        case .studentCards:
            let card = studentCards[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "Student ID"
                textField.text = String(card.studentId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
                textField.text = card.issuedDate.description
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Expiration Date"
                textField.text = card.expirationDate.description
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let studentId = textField.text else { return }
                guard let issuedDate = textField1.text else { return }
                guard let expirationDate = textField2.text else { return }
                
                let editedStudentCard = StudentCard(id: card.id, studentId: Int(studentId)!, issuedDate: PostgresDate(issuedDate)!, expirationDate: PostgresDate(expirationDate)!)
                self?.studentCards[indexPath.row] = editedStudentCard
                let query = "UPDATE \"StudentCards\" SET student_id = $1, issue_date = $2, expiration_date = $3 WHERE card_id = $4"
                DBService.shared.perfromQuery(queryText: query, parameters: [editedStudentCard.studentId, editedStudentCard.issuedDate, editedStudentCard.expirationDate, card.id])
                self?.delegate?.updateUI()
            }))
        case .professorCards:
            let card = professorCards[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "Professor ID"
                textField.text = String(card.professorId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
                textField.text = card.issuedDate.description
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Expiration Date"
                textField.text = card.expirationDate.description
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let professorId = textField.text else { return }
                guard let issuedDate = textField1.text else { return }
                guard let expirationDate = textField2.text else { return }
                
                let editedProfessorCard = ProfessorCard(id: card.id, professorId: Int(professorId)!, issuedDate: PostgresDate(issuedDate)!, expirationDate: PostgresDate(expirationDate)!)
                self?.professorCards[indexPath.row] = editedProfessorCard
                let query = "UPDATE \"ProfessorCards\" SET professor_id = $1, issue_date = $2, expiration_date = $3 WHERE card_id = $4"
                DBService.shared.perfromQuery(queryText: query, parameters: [editedProfessorCard.professorId, editedProfessorCard.issuedDate, editedProfessorCard.expirationDate, card.id])
                self?.delegate?.updateUI()
            }))
        case .libraryEmployees:
            let employee = libraryEmployees[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "First Name"
                textField.text = employee.firstName
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Last Name"
                textField.text = employee.lastName
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Card Number"
                textField.text = employee.libraryCardNumber
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                
                guard let firstName = textField.text else { return }
                guard let lastName = textField1.text else { return }
                guard let cardNumber = textField2.text else { return }
                
                let editedLibrarian = LibraryEmployee(id: employee.id, firstName: firstName, lastName: lastName, libraryCardNumber: cardNumber)
                self?.libraryEmployees[indexPath.row] = editedLibrarian
                let query = "UPDATE \"LibraryStaff\" SET first_name = $1, last_name = $2, library_card_number = $3) WHERE staff_id = $4"
                DBService.shared.perfromQuery(queryText: query, parameters: [firstName, lastName, cardNumber, employee.id])
                self?.delegate?.updateUI()
            }))
        case .issuedBooks:
            let issuedBook = issuedBooks[indexPath.row]
            alertController.addTextField { textField in
                textField.placeholder = "Book ID"
                guard let bookId = issuedBook.bookId else { return }
                textField.text = String(bookId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Student Card ID"
                guard let studentCardId = issuedBook.studentCardId else { return }
                textField.text = String(studentCardId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Professor Card ID"
                guard let professorCardId = issuedBook.professorCardId else { return }
                textField.text = String(professorCardId)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued By ID"
                textField.text = String(issuedBook.issuedById)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Issued Date"
                textField.text = issuedBook.issuedDate.description
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Return Date"
                textField.text = issuedBook.returnDate.description
            }
            
            alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] action in
                let textField = alertController.textFields![0] as UITextField
                let textField1 = alertController.textFields![1] as UITextField
                let textField2 = alertController.textFields![2] as UITextField
                let textField3 = alertController.textFields![3] as UITextField
                let textField4 = alertController.textFields![4] as UITextField
                let textField5 = alertController.textFields![5] as UITextField
                
                guard let bookId = textField.text else { return }
                guard let studentCardId = textField1.text else { return }
                guard let professorCardId = textField2.text else { return }
                guard let issuedById = textField3.text else { return }
                guard let issuedDate = textField4.text else { return }
                guard let returnDate = textField5.text else { return }
                
                let editedBookIssue = BookIssue(id: issuedBook.id, bookId: Int(bookId) ?? 0, professorCardId: Int(professorCardId) ?? 0, studentCardId: Int(studentCardId) ?? 0, issuedById: Int(issuedById) ?? 0, issuedDate: PostgresDate(issuedDate)!, returnDate: PostgresDate(returnDate)!)
                self?.issuedBooks[indexPath.row] = editedBookIssue
                let query = "UPDATE \"BookIssues\" SET book_id = $1, student_card_id = $2, professor_card_id = $3, issued_by_id = $4, issue_date = $5, return_date = $6 WHERE issue_id = $7"
                DBService.shared.perfromQuery(queryText: query, parameters: [bookId, studentCardId, professorCardId, issuedById, issuedDate, returnDate, issuedBook.id])
                self?.delegate?.updateUI()
            }))
        }
        return alertController
    }
}

// MARK: - Book
struct Book {
    var id: Int?
    var title: String
    var publisherId: Int?
    var authorId: Int?
    var publicationYear: Int?
    var availableCopies: Int?
}

// MARK: - Student
struct Student {
    var id: Int?
    var firstName: String
    var lastName: String
}

// MARK: - Professor
struct Professor {
    var id: Int?
    var firstName: String
    var lastName: String
}

// MARK: - Author
struct Author {
    var id: Int?
    var firstName: String
    var lastName: String
}

// MARK: - Publisher
struct Publisher {
    var id: Int?
    var name: String
    var address: String
}

// MARK: - Library Employee
struct LibraryEmployee {
    var id: Int?
    var firstName: String
    var lastName: String
    var libraryCardNumber: String?
}

// MARK: - Student Card
struct StudentCard {
    var id: Int?
    var studentId: Int
    var issuedDate: PostgresDate
    var expirationDate: PostgresDate
}

// MARK: - Professor Card
struct ProfessorCard {
    var id: Int?
    var professorId: Int
    var issuedDate: PostgresDate
    var expirationDate: PostgresDate
}

// MARK: - Book Issue
struct BookIssue {
    var id: Int?
    var bookId: Int?
    var professorCardId: Int?
    var studentCardId: Int?
    var issuedById: Int
    var issuedDate: PostgresDate
    var returnDate: PostgresDate
}
