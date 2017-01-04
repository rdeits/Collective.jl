# http://web.mit.edu/puzzle/www/2012/puzzles/william_s_bergman/behave/

@testset "behave" begin
    f1 = best_feature(["annieproulx", "commutative", "hugoweaving", "mountaindew", "mozambique", "sequoia"])
    @test f1.description == "has 5 unique vowels"



    f3 = best_feature(["almost", "biopsy", "chimp", "films", "ghost", "tux"])
    @test f3.description == "has at least 1 reverse alphabetical bigrams"

    f4 = best_feature(["balked", "barspoon", "highnoon", "klutzy", "onyx", "posted"])
    @test f4.description == "has at least 2 reverse sequential bigrams"

end
