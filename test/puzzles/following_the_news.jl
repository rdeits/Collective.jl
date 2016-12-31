# http://web.mit.edu/puzzle/www/2013/coinheist.com/get_smart/following_the_news/index.html
@testset  "following the news" begin
    f = best_feature(["andrewlin",
                      "betatests",
                      "clockofthelongnow",
                      "decompressor",
                      "eugene",
                      "fungusproofsword",
                      "gleemen",
                      "hansardise",
                      "interpose"])
    @test f.description == "has 4 cardinal direction abbreviations (NESW)"
end