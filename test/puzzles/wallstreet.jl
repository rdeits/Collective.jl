# http://web.mit.edu/puzzle/www/2011/puzzles/civilization/meta/wall_street.html
@testset "wallstreet meta" begin
    f = best_feature(["autumn", "badminton", "trafficpylon", "american", "ingrid", "mercury", "corncake", "gooier", "triskelion", "wandering"], 1)
    @test f.description == "contains 1 repeated letters"
end
