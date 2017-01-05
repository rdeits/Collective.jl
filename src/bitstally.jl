module BitsTallies

import Base: getindex, +, -

const BITS = 5
const mask = UInt8(2 ^ BITS - 1)
const offsets = [BITS * i for i in 0:25]
const charmasks = [UInt128(1) << x for x in offsets]

"""
The BitsTally uses a single unsigned integer to store counts 
for every letter in 'a':'z'. This lets us compute those tallies
without allocating an array, and compare them using simple 
integer equality. 

The way we do this is to divide up the internal 128-bit integer into 26
blocks. Each block is 5 bits long, except the final block which is only 3 bits
long. We can use each of those blocks to store a 5-bit count of a given
letter. We store the counts for the letter 'a' in the low-order bits, which
leaves the awkward 3-bit block for 'z'. So this will overflow if a word
contains more than 7 'z's. or more than 31 of any other letter.
"""
immutable BitsTally
    data::UInt128

    BitsTally(data=0) = new(data)
end

"""
Add a single count for char c to the tally t. 
"""
+(t::BitsTally, c::Char) = BitsTally(t.data + charmasks[convert(Int, c - 'a' + 1)])

-(t::BitsTally, c::Char) = BitsTally(t.data - charmasks[convert(Int, c - 'a' + 1)])

function BitsTally(s::String)
    t = BitsTally()
    for c in s
        t += c
    end
    t
end

"""
Strip the appropriate bits out of the storage UInt128 to return the count of
the given letter as a UInt8. 
"""
getindex(t::BitsTally, c::Char) = mod((t.data >> offsets[convert(Int, c - 'a' + 1)]) & mask, UInt8)

isanagram(t1::BitsTally, t2::BitsTally) = t1.data == t2.data

"""
Returns true iff t1 is a transaddition of t2. That is, the letters of t2
can be rearranged along with one extra letter to make the letters of t1. 
"""
function istransaddition(t1::BitsTally, t2::BitsTally)
    d = t1.data - t2.data
    for m in charmasks
        if d == m
            return true
        end
    end
    false
end

end
