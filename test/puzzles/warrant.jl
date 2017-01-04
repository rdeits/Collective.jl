# http://web.mit.edu/puzzle/www/1999/puzzles/1Gumshoe/Warrants1/w1.2/w1.2.html
@testset "warrant 1.2" begin
    for (names, common_letter) in [
        (["racerx", "americanmaid", "kodachi", "ladyjane"], 'a'),
        (["brain", "judyjetson", "jonnyquest", "jeannette"], 'n'),
        (["kenshin", "lisasimpson", "michiganjfrog", "sheila"], 'i'),
        (["bedtimebear", "sherman", "stimpy", "mrmagoo"], 'm'),
        (["bettyboop", "sweetpollypurebred", "skeletor", "firefly"], 'e')]
        f = best_feature(names, 0)
        @test f.description == "contains at least 1 '$common_letter's"
    end
end
