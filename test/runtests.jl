using Collective
using Base.Test

words = lowercase.(strip.(split(readstring("../data/113809of.fic"))))
corpus = Collective.Corpus(words[1:Int(round(length(words) / 10000)):end])

function best_feature(wordlist, allowed_misses=length(wordlist))
    results = Collective.analyze(corpus, wordlist)
    for result in results[1:100:end]
        @test result.evaluate.(wordlist) == result.satisfied
    end
    # r, _ = findmin(results)
    r, _ = findmin(r for r in results if sum(r.satisfied) >= length(r.satisfied) - allowed_misses)
    r
end

include("puzzles/behave.jl")
include("puzzles/wordplay.jl")
include("puzzles/venntersections.jl")
include("puzzles/lastresort.jl")
include("puzzles/podofdolphins.jl")
include("puzzles/rubik.jl")
include("puzzles/wallstreet.jl")
