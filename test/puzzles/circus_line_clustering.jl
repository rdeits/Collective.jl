# http://www.mit.edu/~puzzle/2012/puzzles/a_circus_line/solution/

@testset "circus line meta" begin
    puzzle = wordlist(IOBuffer("""
        BOOKWORM
        COCOON
        COSPONSORS
        ENTICING
        ENUMERATE
        MEDLEY
        OCTOPOD
        PINHEAD
        SUBSTITUTE
        TORCHWOOD
        """))

    cluster = best_cluster(corpus, puzzle)
    @test cluster.feature.description == "contains 3 'o's"
    @test sort(cluster.words) == ["bookworm","cocoon","cosponsors","octopod","torchwood"]
end