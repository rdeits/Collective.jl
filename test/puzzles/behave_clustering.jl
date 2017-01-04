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
    cluster = Collective.best_cluster(corpus, behave, 6)
    @test sort(cluster.words) == ["almost", "biopsy", "chimp", "films", "ghost", "tux"]
    @test cluster.feature.description == "has at least 1 reverse alphabetical bigrams"
    @test !any(cluster.feature.satisfied)
end
