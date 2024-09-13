import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenLowerCase(string_array, predicate) {
  const firstString = string_array.find(predicate)
  return firstString?.toLowerCase()
}

export function* powersGenerator({ofBase, upTo}) {
  let power = 1
  while (power <= upTo) {
    yield power
    power = ofBase * power
  }
}

export function say(word) {
  if (word == undefined) {
    return ""
  }
  return function(next) {
    if (next == undefined) {
      return word
    }
    else {
      return say(word + " " + next)
    } 
  }
}

import { promises as fs } from 'fs';

export async function meaningfulLineCount(fileName, encoding = 'utf-8') {
  try {
       
    const data = await fs.readFile(fileName, encoding);
    const lines = data.split('\n');
    let lineCount = 0;
    for (const line of lines) {
      const strippedLine = line.trim();
      if (strippedLine && !strippedLine.startsWith('#')) {
        lineCount += 1;
      }
    }
    return lineCount;

  } 
  catch (error) {
    return Promise.reject(new Error(`File does not exist: ${fileName}`));
  }
}

export class Quaternion {
  constructor(a, b, c, d) {
    Object.defineProperty(this, 'a', { value: a, writable: false, enumerable: true });
    Object.defineProperty(this, 'b', { value: b, writable: false, enumerable: true });
    Object.defineProperty(this, 'c', { value: c, writable: false, enumerable: true });
    Object.defineProperty(this, 'd', { value: d, writable: false, enumerable: true });
    Object.freeze(this);
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  toString() {
    const parts = [];

    if (this.a !== 0) {
      parts.push(`${this.a}`);
    }

    if (this.b !== 0) {
      if (this.b === 1) parts.push("+i");
      else if (this.b === -1) parts.push("-i");
      else parts.push(`${this.b >= 0 ? `+${this.b}` : `${this.b}`}i`);
    }

    if (this.c !== 0) {
      if (this.c === 1) parts.push("+j");
      else if (this.c === -1) parts.push("-j");
      else parts.push(`${this.c >= 0 ? `+${this.c}` : `${this.c}`}j`);
    }

    if (this.d !== 0) {
      if (this.d === 1) parts.push("+k");
      else if (this.d === -1) parts.push("-k");
      else parts.push(`${this.d >= 0 ? `+${this.d}` : `${this.d}`}k`);
    }

    let result = parts.join('');

    if (result.startsWith('+')) {
      result = result.slice(1);
    }

    return result || '0';
  }

  plus(other) {
    if (other instanceof Quaternion) {
      return new Quaternion(
        this.a + other.a,
        this.b + other.b,
        this.c + other.c,
        this.d + other.d
      );
    }
    throw new TypeError('Argument must be an instance of Quaternion');
  }

  times(other) {
    if (other instanceof Quaternion) {
      const a1 = this.a, b1 = this.b, c1 = this.c, d1 = this.d;
      const a2 = other.a, b2 = other.b, c2 = other.c, d2 = other.d;
      return new Quaternion(
        a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
        a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
        a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
        a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
      );
    }
    throw new TypeError('Argument must be an instance of Quaternion');
  }

  equals(other) {
    if (other instanceof Quaternion) {
      return this.a === other.a && this.b === other.b && this.c === other.c && this.d === other.d;
    }
    return false;
  }
}