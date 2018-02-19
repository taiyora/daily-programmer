from itertools import permutations

def to_int(assoc, str):
    '''Converts a string to its associated value.'''

    value = 0

    for i in range(len(str) - 1, -1, -1):
        value += assoc[str[i]] * pow(10, len(str) - 1 - i)

    return value

def check(assoc, inputs, output):
    '''Returns True if the inputs add up to the output.'''

    result = 0

    for i in inputs:
        result += to_int(assoc, i)

        if result > to_int(assoc, output):
            return False

    return result == to_int(assoc, output)

# Get input cryptarithm
crypt = input()

# Reduce it to a more simple format
crypt = crypt.replace('+', '')
crypt = crypt.replace('==', '')

# Get the set of characters used in the cryptarithm
crypt_set = set(crypt)
crypt_set.remove(' ')

# Split the words into inputs and output
words = crypt.split()
inputs = words[:-1]
output = words[-1]

for p in permutations(range(10), len(crypt_set)):
    assoc = dict(zip(crypt_set, p))

    # Skip this permutation if a number has a leading 0
    for word in words:
        if assoc[word[0]] == 0:
            continue

    if check(assoc, inputs, output):
        print(assoc)
        break
