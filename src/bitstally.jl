module BitsTallies

import Base: getindex, +

const BITS = 5
const mask = UInt8(2 ^ BITS - 1)
const offsets = [BITS * i for i in 0:25]
const charmasks = [UInt128(1) << x for x in offsets]

immutable BitsTally
    data::UInt128

    BitsTally(data=0) = new(data)
end

+(t::BitsTally, c::Char) = BitsTally(t.data + charmasks[convert(Int, c - 'a' + 1)])

function BitsTally(s::String)
    t = BitsTally()
    for c in s
        t += c
    end
    t
end

getindex(t::BitsTally, c::Char) = mod((t.data >> offsets[convert(Int, c - 'a' + 1)]) & mask, UInt8)

isanagram(t1::BitsTally, t2::BitsTally) = t1.data == t2.data

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
