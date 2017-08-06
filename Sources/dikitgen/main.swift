import Foundation
import DIKit
import SourceKittenFramework

struct A: Injectable {
    struct Dependency {}
    init(dependency: Dependency) {}
}

struct B: Injectable {
    struct Dependency {
        let ba: A
    }
    
    init(dependency: Dependency) {}
}

struct C: Injectable {
    struct Dependency {
        let ca: A
        let cd: D
    }
    
    init(dependency: Dependency) {}
}

struct D {}

protocol Resolver: DIKit.Resolver {
    func provideD() -> D
}

let file = File(path: #file)!
let structure = Structure(file: file)
let types = structure.substructures.flatMap(Type.init)
let resolverNameRequiresModuleName = !types.filter({ $0.name == "Resolver" }).isEmpty
let resolverName = resolverNameRequiresModuleName ? "DIKit.Resolver" : "Resolver"
let resolverFunctions = Array(types
    .filter { $0.kind == .protocol }
    .filter { $0.inheritedTypes.contains(resolverName) }
    .map { $0.functions }
    .joined())

let providableTypeNames = resolverFunctions
    .filter { !$0.isInitializer && !$0.isStatic && $0.name.hasPrefix("provide") }
    .flatMap { provider -> String? in
        guard let offset = provider.structure.offset, let length = provider.structure.length else {
            return nil
        }
        
        let start = file.contents.index(file.contents.startIndex, offsetBy: 449)
        let end = file.contents.index(start, offsetBy: 20)
        let components = file.contents[start..<end].components(separatedBy: "->")
        guard let typeName = components.last?.trimmingCharacters(in: .whitespaces) else {
            return nil
        }

        return typeName
    }

let providables = types.filter { providableTypeNames.contains($0.name) }
let injectables = types.filter { $0.isInjectable }
let graph = try! Graph(injectables: injectables, providables: providables)
print(graph.generateCode().content)

