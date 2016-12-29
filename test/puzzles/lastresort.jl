@testset "last resort" begin
    # http://www.maths.usyd.edu.au/ub/sums/puzzlehunt/2016/puzzles/A2S1_Last_Resort.pdf
    f = best_feature(["advent", "achilles", "binary", "norway", "bubbly", "yacht", "anchor"])
    @test f.description == "has 1 reverse alphabetical bigrams"
end
