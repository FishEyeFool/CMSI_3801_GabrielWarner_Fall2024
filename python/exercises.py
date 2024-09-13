from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(string_list, predicate, /):

    for string in string_list:
        if predicate(string):
            return string.lower()

    return None
    

def powers_generator(*, base, limit):
    power = 1
    while power <= limit:
        yield power
        power = power * base


def say(word=None):
    if word == None:
        return ""
    def next_word(next=None):
        if next == None:
            return word
        return say(word + " " + next)
    return next_word

def meaningful_line_count(file_name, encoding='utf-8'):
    line_count = 0
    with open(file_name, 'r', encoding=encoding) as file:
        for line in file:
            stripped_line = line.strip()
            if stripped_line and not stripped_line.startswith('#'):
                line_count += 1
        return line_count

@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __repr__(self):
        """String representation of the quaternion"""
        return f"{self.a} + {self.b}i + {self.c}j + {self.d}k"
    
    def __str__(self):
        parts = []

        if self.a != 0:
            parts.append(f"{self.a}")

        if self.b != 0:
            if self.b == 1:
                parts.append("+i")
            elif self.b == -1:
                parts.append("-i")
            else:
                if self.b > 0 and parts:
                    parts.append(f"+{self.b}i")
                else:
                    parts.append(f"{self.b}i")

        if self.c != 0:
            if self.c == 1:
                parts.append("+j")
            elif self.c == -1:
                parts.append("-j")
            else:
                if self.c > 0 and parts:
                    parts.append(f"+{self.c}j")
                else:
                    parts.append(f"{self.c}j")

        if self.d != 0:
            if self.d == 1:
                parts.append("+k")
            elif self.d == -1:
                parts.append("-k")
            else:
                if self.d > 0 and parts:
                    parts.append(f"+{self.d}k")
                else:
                    parts.append(f"{self.d}k")

        result = "".join(parts)

        if not result:
            return "0"
        if result.startswith("+"):
            result = result[1:]

        return result

    def __add__(self, other):
        """Addition of two quaternions"""
        if isinstance(other, Quaternion):
            return Quaternion(
                self.a + other.a,  
                self.b + other.b,  
                self.c + other.c,  
                self.d + other.d 
            )
        return NotImplemented

    def __mul__(self, other):
        """Multiplication of two quaternions (Hamilton product)"""
        if isinstance(other, Quaternion):
            a1, b1, c1, d1 = self.a, self.b, self.c, self.d
            a2, b2, c2, d2 = other.a, other.b, other.c, other.d

            return Quaternion(
                a1*a2 - b1*b2 - c1*c2 - d1*d2,
                a1*b2 + b1*a2 + c1*d2 - d1*c2,
                a1*c2 - b1*d2 + c1*a2 + d1*b2,
                a1*d2 + b1*c2 - c1*b2 + d1*a2
            )
        return NotImplemented

    def __eq__(self, other):
        """Value-based equality between two quaternions"""
        if isinstance(other, Quaternion):
            return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
        return False

    @property
    def conjugate(self):
        """Return the conjugate of the quaternion"""
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    @property
    def coefficients(self):
        """Return the coefficients (a, b, c, d) as a list"""
        return (self.a, self.b, self.c, self.d)