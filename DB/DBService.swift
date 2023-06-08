//
//  DBService.swift
//  DB
//
//  Created by QwertY on 06.06.2023.
//

import Foundation
import PostgresClientKit

class DBService {
    static let shared = DBService()
    
    private var configuration: ConnectionConfiguration = {
        var configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = "127.0.0.1"
        configuration.database = "library"
        configuration.user = "postgres"
        configuration.credential = .trust
        configuration.ssl = false
        return configuration
    }()
    
    private init() {}
    
    func perfromQuery(queryText: String, parameters: [PostgresValueConvertible]) {
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let statement = try connection.prepareStatement(text: queryText)
            defer { statement.close() }

            let cursor = try statement.execute(parameterValues: parameters)
            cursor.close()
            
        } catch {
            print(error)
        }
    }
    
    func getData(completion: @escaping ((Result<ViewModel, Error>) -> Void)) {
        let viewModel = ViewModel()
        
        getBooks { result in
            switch result {
            case .success(let success):
                viewModel.books = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getStudents { result in
            switch result {
            case .success(let success):
                viewModel.students = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getProfessors { result in
            switch result {
            case .success(let success):
                viewModel.professors = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getAuthors { result in
            switch result {
            case .success(let success):
                viewModel.authors = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getPublishers { result in
            switch result {
            case .success(let success):
                viewModel.publishers = success
            case .failure(let failure):
                completion(.failure(failure))
                
            }
        }
        
        getLibraryEmployees { result in
            switch result {
            case .success(let success):
                viewModel.libraryEmployees = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getStudentCards { result in
            switch result {
            case .success(let success):
                viewModel.studentCards = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getProfessorCards { result in
            switch result {
            case .success(let success):
                viewModel.professorCards = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getBookIssues { result in
            switch result {
            case .success(let success):
                viewModel.issuedBooks = success
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        completion(.success(viewModel))
    }
    
    private func getBooks(completion: @escaping ((Result<[Book], Error>) -> Void)) {
        var books = [Book]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT book_id, title, publication_year, available_copies, author_id, publisher_id FROM \"Books\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }
            
            for row in cursor {
                let columns = try row.get().columns
 
                let id = try columns[0].int()
                let title = try columns[1].string()
                let publicationYear = try columns[2].int()
                let availableCopies = try columns[3].int()
                let author_id = try columns[4].int()
                let publisher_id = try columns[5].int()
            
                let book = Book(id: id, title: title, publisherId: publisher_id, authorId: author_id, publicationYear: publicationYear, availableCopies: availableCopies)
                
                books.append(book)
            }
            completion(.success(books))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getStudents(completion: @escaping ((Result<[Student], Error>) -> Void)) {
        var students = [Student]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT student_id, first_name, last_name FROM \"Students\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
 
                let id = try columns[0].int()
                let firstName = try columns[1].string()
                let lastName = try columns[2].string()
            
                let student = Student(id: id, firstName: firstName, lastName: lastName)
                students.append(student)
            }
            completion(.success(students))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getProfessors(completion: @escaping ((Result<[Professor], Error>) -> Void)) {
        var professors = [Professor]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT professor_id, first_name, last_name FROM \"Professors\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
 
                let id = try columns[0].int()
                let firstName = try columns[1].string()
                let lastName = try columns[2].string()
            
                let professor = Professor(id: id, firstName: firstName, lastName: lastName)
                professors.append(professor)
            }
            completion(.success(professors))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getAuthors(completion: @escaping ((Result<[Author], Error>) -> Void)) {
        var authors = [Author]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT author_id, last_name, first_name FROM \"Authors\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                let id = try columns[0].int()
                let lastName = try columns[1].string()
                let firstName = try columns[2].string()
            
                let author = Author(id: id, firstName: firstName, lastName: lastName)
                authors.append(author)
            }
            completion(.success(authors))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getPublishers(completion: @escaping ((Result<[Publisher], Error>) -> Void)) {
        var publishers = [Publisher]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT publisher_id, name, address FROM \"Publishers\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()
                let name = try columns[1].string()
                let address = try columns[2].string()
            
                let publisher = Publisher(id: id, name: name, address: address)
                publishers.append(publisher)
            }
            completion(.success(publishers))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getLibraryEmployees(completion: @escaping ((Result<[LibraryEmployee], Error>) -> Void)) {
        var libraryEmployees = [LibraryEmployee]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT staff_id, first_name, last_name FROM \"LibraryStaff\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()
                let firstName = try columns[1].string()
                let lastName = try columns[2].string()
            
                let employee = LibraryEmployee(id: id, firstName: firstName, lastName: lastName)
                libraryEmployees.append(employee)
            }
            completion(.success(libraryEmployees))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getProfessorCards(completion: @escaping ((Result<[ProfessorCard], Error>) -> Void)) {
        var professorCards = [ProfessorCard]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT card_id, professor_id, issue_date, expiration_date FROM \"ProfessorCards\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()
                let professorId = try columns[1].int()
                let issuedDate = try columns[2].date()
                let expirationDate = try columns[3].date()
            
                let card = ProfessorCard(id: id, professorId: professorId, issuedDate: issuedDate, expirationDate: expirationDate)
                professorCards.append(card)
            }
            completion(.success(professorCards))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getStudentCards(completion: @escaping ((Result<[StudentCard], Error>) -> Void)) {
        var studentCards = [StudentCard]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT card_id, student_id, issue_date, expiration_date FROM \"StudentCards\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()
                let studentId = try columns[1].int()
                let issuedDate = try columns[2].date()
                let expirationDate = try columns[3].date()
            
                let card = StudentCard(id: id, studentId: studentId, issuedDate: issuedDate, expirationDate: expirationDate)
                studentCards.append(card)
            }
            completion(.success(studentCards))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getBookIssues(completion: @escaping ((Result<[BookIssue], Error>) -> Void)) {
        var issues = [BookIssue]()
        do {
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }

            let text = "SELECT issue_id, book_id, professor_card_id, student_card_id, issued_by_id, issue_date, return_date FROM \"BookIssues\""
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute()
            defer { cursor.close() }

            for row in cursor {
                let columns = try row.get().columns
                
                let id = try columns[0].int()
                let bookId = try columns[1].int()
                let professorCardId = try columns[2].optionalInt()
                let studentCardId = try columns[3].optionalInt()
                let issuedById = try columns[4].int()
                let issuedDate = try columns[5].date()
                let returnDate = try columns[6].date()
            
                let issue = BookIssue(id: id, bookId: bookId, professorCardId: professorCardId, studentCardId: studentCardId, issuedById: issuedById, issuedDate: issuedDate, returnDate: returnDate)
                issues.append(issue)
            }
            completion(.success(issues))
        } catch {
            completion(.failure(error))
        }
    }
}
