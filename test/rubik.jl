# http://web.mit.edu/puzzle/www/2013/coinheist.com/rubik/clockwork_orange/index.html
@testset "rubik" begin
    f = best_feature(["armoredrecon", "hypapante", "commemorativebats", "derricktruck", "brownrot", "attorneysgeneral", "sacrosanct", "impromptu"])
    @test f.description == "contains at least 2 repeated letters"
end
