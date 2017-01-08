# http://web.mit.edu/puzzle/www/2011/puzzles/world1/squared_key/answer/

@testset "squared key" begin
    f = best_feature(wordlist("""
        EIGHTH NOTE, CHAINS, JUNO, PLUTO, COMET, RAIN, FLOWER, SEXTILE, PICK, NEUTER, PISCES, FLEUR-DE-LIS, ALEMBIC, ANCHOR, HOT SPRINGS, SHAMROCK, EARTH, YIN YANG, WHITE FLAG, SATURN, HOT BEVERAGE"""))
    @test f.description == "is the name of a unicode character"
end
