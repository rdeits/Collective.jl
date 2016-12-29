@testset "pod of dolphins" begin
    # http://web.mit.edu/puzzle/www/2015/puzzle/pod_of_dolphins_meta/
    f = best_feature(["citygates", "impulsive", "clickspam", "baptistry", "leviathan", "policecar", "coupdetat", "sforzando", "cartwheel"])
    @test f.description == "has 8 unique letters"
end
