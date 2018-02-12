# Using a bitarray as a Bloom filter, detect repeat values with variable probability of correctness.

# This approach works by taking a number, hashing it X amount of times, converting those hashes to
# max-bounded indices, then setting those indices of a bitarray to True.
# To check if a number has been "seen", just do the same thing but check if all the indices are True.
# If they are, then the number has *probably* been seen.
# False positives are possible, and become more likely the smaller the bitarray is and the more
# values are processed.

# This implementation doesn't remember historical values between runs, as the problem description
# seems to say is a requirement. It'd be easy to add by saving the bitarray to file, but is that what
# is meant?

import Isaac
import mmh3
import sys
from bitarray import bitarray

# PRNG
isaac = Isaac.Isaac()

# Bloom Filter
bfilter_size = 2 ** 25 # ~4.2 Mb
bloom_filter = bitarray(bfilter_size)

# Hashing
do_n_hashes = 5

# Functions
def get_indices(value):
	'''Returns the indices that specify where to store or find the specified value.'''

	indices = []

	for seed in range(0, do_n_hashes):
		index = mmh3.hash(str(value), seed) % bfilter_size
		indices.append(index)

	return indices

def store(value):
	for index in get_indices(value):
		bloom_filter[index] = True

def get(value):
	'''Returns False if the value does not exist (for sure), or True if it exists (probably).'''

	for index in get_indices(value):
		if not bloom_filter[index]:
			return False

	return True

# Run until a unique value is observed twice
if __name__ == '__main__':
	count = 0

	while True:
		value = isaac.rand(sys.maxsize)
		count += 1
		
		if get(value):
			print(value, 'was observed twice, after', count, 'runs')
			break

		store(value)
