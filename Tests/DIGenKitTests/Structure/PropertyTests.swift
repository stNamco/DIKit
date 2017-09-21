//
//  PropertyTests.swift
//  DIGenKitTests
//
//  Created by Yosuke Ishikawa on 2017/09/21.
//

import Foundation
import XCTest
import SourceKittenFramework

@testable import DIGenKit

final class PropertyTests: XCTestCase {
    func test() {
        let code = """
            struct Test {
                var a: A
            }
            """

        let file = File(contents: code)
        let structure = Structure(file: file).substructures.first!
        let type = Type(structure: structure, file: file)
        let property = type?.properties.first

        XCTAssertEqual(property?.name, "a")
        XCTAssertEqual(property?.typeName, "A")
        XCTAssertEqual(property?.isStatic, false)
    }

    func testLet() {
        let code = """
            struct Test {
                let a: A
            }
            """

        let file = File(contents: code)
        let structure = Structure(file: file).substructures.first!
        let type = Type(structure: structure, file: file)
        let property = type?.properties.first

        XCTAssertEqual(property?.name, "a")
        XCTAssertEqual(property?.typeName, "A")
        XCTAssertEqual(property?.isStatic, false)
    }


    func testStatic() {
        let code = """
            struct Test {
                static var a: A
            }
            """

        let file = File(contents: code)
        let structure = Structure(file: file).substructures.first!
        let type = Type(structure: structure, file: file)
        let property = type?.properties.first

        XCTAssertEqual(property?.name, "a")
        XCTAssertEqual(property?.typeName, "A")
        XCTAssertEqual(property?.isStatic, true)
    }

    func testProtocol() {
        let code = """
            protocol Test {
                var a: A { get }
            }
            """

        let file = File(contents: code)
        let structure = Structure(file: file).substructures.first!
        let type = Type(structure: structure, file: file)
        let property = type?.properties.first

        XCTAssertEqual(property?.name, "a")
        XCTAssertEqual(property?.typeName, "A")
        XCTAssertEqual(property?.isStatic, false)
    }
}
