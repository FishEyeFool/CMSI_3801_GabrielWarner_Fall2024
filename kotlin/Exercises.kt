import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

/**
 * Finds the first string in the list that matches the given predicate and converts it to lowercase.
 *
 * @param strings the list of strings to search
 * @param predicate the condition to match
 * @return the first matching string in lowercase, or null if no match is found
 */
fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean) : String? {
    return strings.firstOrNull(predicate)?.lowercase()
}

/**
 * A data class that represents a phrase and allows chaining additional phrases.
 *
 * @property phrase the initial phrase
 */
data class Say(val phrase: String) {

    /**
     * Chains the next phrase to the current phrase.
     *
     * @param nextPhrase the phrase to be added
     * @return a new Say instance with the combined phrase
     */
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}

/**
 * Creates a Say instance with the given phrase.
 *
 * @param phrase the initial phrase (default is an empty string)
 * @return a Say instance
 */
fun say(phrase: String = ""): Say {
    return Say(phrase)
}

/**
 * Counts the number of meaningful lines in a file.
 * A meaningful line is one that is not empty and does not start with '#'.
 *
 * @param fileName the name of the file to read
 * @return the number of meaningful lines
 * @throws IOException if an I/O error occurs
 */
@Throws(IOException::class)
fun meaningfulLineCount(fileName: String): Long {
    return runCatching {
        BufferedReader(FileReader(fileName)).use { reader ->
            reader.lines()
                .filter { it.trim().isNotEmpty() }
                .filter { !it.trim().startsWith("#") }
                .count()
        }
    }.getOrElse { e ->
        if (e is NoSuchFileException || e is java.io.FileNotFoundException) {
            throw IOException("No such file")
        } else {
            throw e
        }
    }
}

/**
 * A data class representing a quaternion, which is a mathematical object used in three-dimensional
 * rotations and complex number extensions. This class ensures immutability and provides
 * essential operations for quaternion arithmetic.
 *
 * Each quaternion is represented by four coefficients: a, b, c, and d, corresponding to
 * the components 1, i, j, and k respectively. The class includes methods for addition,
 * multiplication, conjugation, and obtaining the coefficients as a list.
 *
 * Static constants ZERO, I, J, and K are provided for convenience, representing the
 * zero quaternion and the unit quaternions along the i, j, and k axes.
 *
 * @property a the scalar part of the quaternion
 * @property b the coefficient of the i component
 * @property c the coefficient of the j component
 * @property d the coefficient of the k component
 * @throws IllegalArgumentException if any of the coefficients are NaN
 */
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    init {
        require(!a.isNaN() && !b.isNaN() && !c.isNaN() && !d.isNaN()) { "Coefficients cannot be NaN" }
    }

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)

        operator fun invoke(a: Double, b: Double, c: Double, d: Double): Quaternion {
            return Quaternion(a, b, c, d)
        }
    }

    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }

    fun conjugate(): Quaternion {
        return Quaternion(a, -b, -c, -d)
    }

    fun coefficients(): List<Double> {
        return listOf(a, b, c, d)
    }

    override fun toString(): String {
        val coefficients = listOf(a, b, c, d)
        val suffixes = listOf("", "i", "j", "k")
        val s = StringBuilder()

        for (i in coefficients.indices) {
            val c = coefficients[i]
            if (c == 0.0) continue
            if (c < 0) {
                s.append("-")
            } else if (s.isNotEmpty()) {
                s.append("+")
            }
            if (kotlin.math.abs(c) != 1.0 || i == 0) {
                s.append(kotlin.math.abs(c))
            }
            s.append(suffixes[i])
        }
        return if (s.isNotEmpty()) s.toString() else "0"
    }
}
 
/**
 * A sealed interface representing a binary search tree (BST).
 * It permits two implementations: Empty and Node.
 */
sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree

    object Empty : BinarySearchTree {
        override fun size() = 0
        override fun contains(value: String) = false
        override fun insert(value: String) = Node(value, this, this)
        override fun toString() = "()"
    }

    /**
     * A data class representing a non-empty node in the BST.
     *
     * @property value the value of the node
     * @property left the left subtree
     * @property right the right subtree
     */
    data class Node(val value: String, val left: BinarySearchTree, val right: BinarySearchTree) : BinarySearchTree {
        override fun size() = 1 + left.size() + right.size()
        override fun contains(value: String): Boolean {
            return when {
                this.value == value -> true
                value < this.value -> left.contains(value)
                else -> right.contains(value)
            }
        }

        override fun insert(value: String): BinarySearchTree {
            return when {
                value < this.value -> Node(this.value, left.insert(value), right)
                else -> Node(this.value, left, right.insert(value))
            }
        }

        override fun toString(): String {
            val leftStr = if (left is Empty) "" else left.toString()
            val rightStr = if (right is Empty) "" else right.toString()
            return "($leftStr$value$rightStr)"
        }
    }
}
