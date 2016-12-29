# http://web.mit.edu/puzzle/www/2012/puzzles/william_s_bergman/behave/

@testset "behave clusters" begin
    behave = shuffle([
            "hugoweaving",
            "mountaindew",
            "mozambique",
            "sequoia",
            "annotation",
            "artificial",
            "individual",
            "omnivorous",
            "onlocation",
            "almost",
            "biopsy",
            "chimp",
            "films",
            "ghost",
            "tux",
            "balked",
            "highnoon",
            "posted"])
    c1, f1 = Collective.best_cluster(corpus, behave, 6)
    @test sort(c1) == ["almost", "biopsy", "chimp", "films", "ghost", "tux"]
    @test f1.description == "has at least 1 reverse alphabetical bigrams"
    @test !any(f1.satisfied)
end
