# http://huntception.com/puzzle/1_2_3/solution/
@testset "1, 2, 3" begin
    f = best_feature(["season", "saveup", "ecowas", "ignore", "sluice", "hosni", "inbed", "barbeau", "museum", "tobiah", "unsew", "dolce", "anaphia", "teenage"])
    @test f.description == "has 3 unique consonants"
end