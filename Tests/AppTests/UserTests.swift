//
//  File.swift
//  
//
//  Created by Marlon Mueller Soppart on 12/21/21.
//

@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    let userURI = "/api/users"
    var app: Application!
    
    override func setUpWithError() throws {
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testUsersCanBeRetrievedFromAPI() async throws {
        let user = try await User.create(email: "email1@mail.com", username: "u1", password: "password1", on: app.db)
        _ = try await User.create(email: "email2@mail.com", username: "u2", password: "password2", on: app.db)
        
        try app.test(.GET, userURI, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let users = try response.content.decode([User.Public].self)
            
            XCTAssertEqual(users.count, 3)
            
            XCTAssertEqual(users[0].username, "mmuellersoppart")
            
            XCTAssertEqual(users[1].username, user.username)
            XCTAssertEqual(users[1].id, user.id)
            // TODO: test for password not being there. 
        })
    }
//    
//    func testUserCanBeSavedWithAPI() async throws {
//        let user = try await User.create(email: "e1@mail.com", username: "u1", password: "p1", on: app.db)
//        
//        try app.test(.POST, userURI, )
//    }
}

