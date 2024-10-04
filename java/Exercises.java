import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.stream.Stream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }
    
    /**
     * Finds the first string in the list that matches the given predicate,
     * then converts it to lowercase.
     *
     * @param stringList the list of strings to search
     * @param predicate the condition to match
     * @return an Optional containing the first matching string in lowercase, or an empty Optional if no match is found
     */
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .findFirst()
                .map(String::toLowerCase);
    }

    static record WordChain(String phrase) {

        /**
         * Adds a word to the current phrase and returns a new WordChain.
         *
         * @param word the word to add
         * @return a new WordChain with the added word
         */
        public WordChain and(String word) {
            return new WordChain(phrase + " " + word);
        }
    }

    /**
     * Creates an empty WordChain.
     *
     * @return a new WordChain with an empty phrase
     */
    public static WordChain say() {
        return new WordChain("");
    }

    /**
     * Creates a WordChain starting with the given word.
     *
     * @param word the initial word
     * @return a new WordChain with the initial word
     */
    public static WordChain say(String word) {
        return new WordChain(word);
    }

    /**
     * Counts the number of meaningful lines in a file.
     * A meaningful line is one that is not empty and does not start with '#'.
     *
     * @param fileName the name of the file to read
     * @return the number of meaningful lines
     * @throws IOException if an I/O error occurs
     */
    public static int meaningfulLineCount(String fileName) throws IOException {
        long lineCount;
        try (Stream<String> lines = Files.lines(Paths.get(fileName))) {
            lineCount = lines
                .filter(line -> !line.trim().isEmpty())
                .filter(line -> !line.trim().startsWith("#"))
                .count();
            
        } catch (IOException e) {
            if (e instanceof java.nio.file.NoSuchFileException) {
                throw new FileNotFoundException("No such file");
            } else {
                throw e;
            }
        }
        return (int) lineCount;
    }
}

/**
 * A record representing a quaternion, which is a mathematical object used in three-dimensional
 * rotations and complex number extensions. This record ensures immutability and provides
 * essential operations for quaternion arithmetic.
 *
 * Each quaternion is represented by four coefficients: a, b, c, and d, corresponding to
 * the components 1, i, j, and k respectively. The record includes methods for addition,
 * multiplication, conjugation, and obtaining the coefficients as a list.
 *
 * Static constants ZERO, I, J, and K are provided for convenience, representing the
 * zero quaternion and the unit quaternions along the i, j, and k axes.
 *
 * @param a the scalar part of the quaternion
 * @param b the coefficient of the i component
 * @param c the coefficient of the j component
 * @param d the coefficient of the k component
 * @throws IllegalArgumentException if any of the coefficients are NaN
 */
record Quaternion (double a, double b, double c, double d) {

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    public final static Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public final static Quaternion I = new Quaternion(0, 1, 0, 0);
    public final static Quaternion J = new Quaternion(0, 0, 1, 0);
    public final static Quaternion K = new Quaternion(0, 0, 0, 1);

    Quaternion plus(Quaternion other) {
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }

    Quaternion times(Quaternion other) {
        return new Quaternion(
                a * other.a - b * other.b - c * other.c - d * other.d,
                a * other.b + b * other.a + c * other.d - d * other.c,
                a * other.c - b * other.d + c * other.a + d * other.b,
                a * other.d + b * other.c - c * other.b + d * other.a);
    }

    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder();
        double[] coefficients = {a, b, c, d};
        String[] suffixes = {"", "i", "j", "k"};

        for (int i = 0; i < coefficients.length; i++) {
            double c = coefficients[i];
            if (c == 0) continue;
            if (c < 0) {
                s.append("-");
            } else if (s.length() > 0) {
                s.append("+");
            }
            if (Math.abs(c) != 1 || i == 0) {
                s.append(Math.abs(c));
            }
            s.append(suffixes[i]);
        }
        return s.length() > 0 ? s.toString() : "0";
    }

}

/**
 * A sealed interface representing a binary search tree (BST).
 * It permits two implementations: Empty and Node.
 */
sealed interface BinarySearchTree permits Empty, Node{
    int size();
    boolean contains(String value);
    BinarySearchTree insert(String value);
}

/**
 * A final record representing an empty node in the BST.
 */
final record Empty() implements BinarySearchTree {
    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean contains(String value) {
        return false;
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, this, this);
    }

    @Override
    public String toString() {
        return "()";
    }
}

/**
 * A final class representing a non-empty node in the BST.
 */
final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    /**
     * Constructs a new Node with the specified value and subtrees.
     *
     * @param value the value of the node
     * @param left the left subtree
     * @param right the right subtree
     */
    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }

    @Override
    public boolean contains(String value) {
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }
    
    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else {
            return new Node(this.value, left, right.insert(value));
        }
    }

    @Override
    public String toString() {
        String leftStr = left instanceof Empty ? "" : left.toString();
        String rightStr = right instanceof Empty ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")";
    }
}
