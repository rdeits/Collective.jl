# http://web.mit.edu/puzzle/www/2013/coinheist.com/rubik/clockwork_orange/index.html
@testset "rubik clockwork orange meta" begin
    f = best_feature(["armoredrecon", "hypapante", "commemorativebats", "derricktruck", "brownrot", "attorneysgeneral", "sacrosanct", "impromptu"], 1)
    @test f.description == "has at least 2 letters repeated exactly 2 times each"
end
