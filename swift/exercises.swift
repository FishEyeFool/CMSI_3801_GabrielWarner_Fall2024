import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

/**
 * Finds the first string in the array that matches the given predicate and converts it to lowercase.
 *
 * - Parameters:
 *   - of: The array of strings to search.
 *   - satisfying: The condition to match.
 * - Returns: The first matching string in lowercase, or nil if no match is found.
 */
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

/**
 * A class that represents a phrase and allows chaining additional phrases.
 *
 * - Property phrase: The initial phrase.
 */
class Say {
    private var _phrase: String

    var phrase: String {
        return _phrase
    }

    init(phrase: String) {
        self._phrase = phrase
    }

    /**
     * Chains the next phrase to the current phrase.
     *
     * - Parameter nextPhrase: The phrase to be added.
     * - Returns: A new Say instance with the combined phrase.
     */
    func and(_ nextPhrase: String) -> Say {
        return Say(phrase: "\(_phrase) \(nextPhrase)")
    }
}

/**
 * Creates a Say instance with the given phrase.
 *
 * - Parameter phrase: The initial phrase (default is an empty string).
 * - Returns: A Say instance.
 */
func say(_ phrase: String = "") -> Say {
    return Say(phrase: phrase)
}

/**
 * Counts the number of meaningful lines in a file.
 * A meaningful line is one that is not empty, not made up entirely of whitespace, and does not start with '#'.
 *
 * - Parameter fileName: The name of the file to read.
 * - Returns: A Result containing the number of meaningful lines or an error.
 */
func meaningfulLineCount(_ fileName: String) async -> Result<Int, NoSuchFileError> {
    guard let contents = try? String(contentsOfFile: fileName) else {
        return .failure(NoSuchFileError())
    }
    return .success(contents.split(separator: "\n").filter { line in
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && !trimmed.hasPrefix("#")
    }.count)
}

/**
 * A struct representing a quaternion, which is a mathematical object used in three-dimensional
 * rotations and complex number extensions. This struct ensures immutability and provides
 * essential operations for quaternion arithmetic.
 *
 * Each quaternion is represented by four coefficients: a, b, c, and d, corresponding to
 * the components 1, i, j, and k respectively. The struct includes methods for addition,
 * multiplication, conjugation, and obtaining the coefficients as an array.
 *
 * Static constants ZERO, I, J, and K are provided for convenience, representing the
 * zero quaternion and the unit quaternions along the i, j, and k axes.
 *
 * - Properties:
 *   - a: The scalar part of the quaternion.
 *   - b: The coefficient of the i component.
 *   - c: The coefficient of the j component.
 *   - d: The coefficient of the k component.
 *
 * - Methods:
 *   - init(a:b:c:d:): Initializes a new quaternion with the given coefficients.
 *   - conjugate: Returns the conjugate of the quaternion.
 *   - coefficients: Returns the coefficients of the quaternion as an array.
 *   - description: Returns a string representation of the quaternion.
 *
 * - Operators:
 *   - static func +(_:_:): Adds two quaternions.
 *   - static func *(_:_:): Multiplies two quaternions.
 *
 * - Static Constants:
 *   - ZERO: The zero quaternion.
 *   - I: The unit quaternion along the i axis.
 *   - J: The unit quaternion along the j axis.
 *   - K: The unit quaternion along the k axis.
 */
struct Quaternion: CustomStringConvertible, Equatable {
    let a, b, c, d: Double

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    static let ZERO = Quaternion(a: 0.0, b: 0.0, c: 0.0, d: 0.0)
    static let I = Quaternion(a: 0.0, b: 1.0, c: 0.0, d: 0.0)
    static let J = Quaternion(a: 0.0, b: 0.0, c: 1.0, d: 0.0)
    static let K = Quaternion(a: 0.0, b: 0.0, c: 0.0, d: 1.0)

    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        )
    }

    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    var coefficients: [Double] {
        return [a, b, c, d]
    }

    var description: String {
        let coefficients = [a, b, c, d]
        let suffixes = ["", "i", "j", "k"]
        var s = ""

        for (i, coefficient) in coefficients.enumerated() {
            if coefficient == 0.0 { continue }
            if coefficient < 0 {
                s.append("-")
            } else if !s.isEmpty {
                s.append("+")
            }
            if abs(coefficient) != 1.0 || i == 0 {
                s.append("\(abs(coefficient))")
            }
            s.append(suffixes[i])
        }
        return s.isEmpty ? "0" : s
    }
}

/**
 * An enum representing a binary search tree (BST).
 * It permits two cases: Empty and Node.
 */
enum BinarySearchTree: CustomStringConvertible {
    case empty
    indirect case node(BinarySearchTree, String, BinarySearchTree)

    /**
     * The size of the BST.
     * - Returns: The number of nodes in the BST.
     */
    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return 1 + left.size + right.size
        }
    }

    /**
     * Checks if the BST contains a given value.
     * - Parameter value: The value to search for.
     * - Returns: True if the value is found, false otherwise.
     */
    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, v, right):
            if value < v {
                return left.contains(value)
            } else if value > v {
                return right.contains(value)
            } else {
                return true
            }
        }
    }

    /**
     * Inserts a new value into the BST.
     * - Parameter value: The value to insert.
     * - Returns: A new BST with the value inserted.
     */
    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, value, .empty)
        case let .node(left, v, right):
            if value < v {
                return .node(left.insert(value), v, right)
            } else if value > v {
                return .node(left, v, right.insert(value))
            } else {
                return self
            }
        }
    }

    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, value, right):
            return "(\(left)\(value)\(right))"
        }
    }
}
