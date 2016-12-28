using Collective
using Base.Test

words = lowercase.(strip.(split(readstring("../data/113809of.fic"))))
corpus = Collective.Corpus(words[1:Int(round(length(words) / 10000)):end])

function best_feature(wordlist)
    results = Collective.analyze(corpus, wordlist)
    for result in results[1:100:end]
        @test result.evaluate.(wordlist) == result.satisfied
    end
    r, _ = findmin(r for r in results if all(r.satisfied))
    r
end

include("wordplay.jl")
include("venntersections.jl")

@testset "last resort" begin
    # http://www.maths.usyd.edu.au/ub/sums/puzzlehunt/2016/puzzles/A2S1_Last_Resort.pdf
    f = best_feature(["advent", "achilles", "binary", "norway", "bubbly", "yacht", "anchor"])
    @test f.description == "has 1 reverse alphabetical bigrams"
end
