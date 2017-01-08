# http://web.mit.edu/puzzle/www/2012/puzzles/watson_2_0/r_e_s_p_e_c_t/
@testset "R.E.S.P.E.C.T" begin
    f = best_feature(String.(shuffle.(collect.(wordlist("""
        ABMNOT
        AENORTY
        BCEKLORSTU
        BFLU
        CDEILNOTU
        CIK
        GIOPS
        ABCEKNO
        ABLMNOR
        ACEILMPR
        ACEILTUV
        HINOPSY
        ACDEIKLNST
        ACDEMY
        ACEMZ
        ACHIMNST
        DEIO
        GLNOTU
        ABCEGILORTY
        ABEINORTX
        ACRTUY
        AGHTUY
        CDEIMNOPU
        ACDILMOPT
        ACHILP
        BCEKUY
        MNOTU
        """)))), 5)
    @test f.description == "has a 1-letter transaddition"
end
