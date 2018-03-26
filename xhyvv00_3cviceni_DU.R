############         4ST315 - Cviceni 3 - Vojtech Hyvnar - xhyvv00              #################
#########################################Priklad 1###############################################
#Zjistete, kolik cisel Fibonacciho sekvence je mezi cisly 350 a 2400.
#Kolik je sudych, kolik je delitelnych 3 a nejmensi delitelne 6.
#       Funkce, ktera ma jako input horni a dolni limit casti Fibonacciho sekvence, 
#       kterou chceme spocitat/zobrazit.
#       Prvni dve jednicky jsem trochu obesel,
#       posledni ukol je z lenosti zpracovan v ramci funkce 
#       (trochu predpokladame horni hranici takovou, jaka je v zadani)
#       V pripade samostatneho zpracovani by byla podminka pro minumum zhruba takto:
#           if(n %% 6 == 0) break 
#       a nachazela by se o radek nize, nez je ted.
fibonacci <- function(dolni_limit, horni_limit){
    n1 = n2 = n = 1
    count = 3
    fibo <- c(n1, n2)
repeat {
    n <- n1 + n2
    if(n > horni_limit) break
    fibo[count] <- n
    n1 <- n2
    n2 <- n
    count <- count + 1
}
    ff <- fibo[fibo >= dolni_limit] #Z popisu funkce vyplyva, ze horni limit lze vynechat.
    print(paste("Mezi", dolni_limit, "a", horni_limit,
                "jsou ve Fibonacciho posloupnosti tato cisla:",
                paste(ff, collapse = ", ")))
    print(paste("Z toho je sudych", length(ff [ff %% 2 == 0]), "a to:", 
                paste(ff [ff %% 2 == 0], collapse = ", " )))
    print(paste("Delitelnych tremi je", length(ff [ff %% 3 == 0]), "a to:",
                paste(ff [ff %% 3 == 0], collapse = ", " )))
    print(paste("Nejmensi delitelne cislo Fibonacciho posloupnosti delitelne 6 je",
                min(fibo [fibo %% 6 == 0])))
}
fibonacci(350, 2400)

##########################################Priklad 2#############################################
#Pomoci control flow struktur najdete nejvyssi cislo vektoru.
max_vektoru <- function(vek) {
    nejvyssi <- numeric(1)
    for (i in 1:length(vek)) {
        if(vek[i] > nejvyssi) {
            nejvyssi <- vek[i]
        }
    }
    print(paste("Nejvyssi cislo je", nejvyssi))
}
vek <- c(1,4,38,29,90,32)
max_vektoru(vek)

#Vytvorte matici. 
x <- matrix(c(1,7,9,2), nrow = 2, byrow = F)
#Vypocitejte determinant matice x.
det(x)

#Vypocitejte nejvyssi charakteristicke cislo matice x.
#I kdyz mam only.values = T, tak mi to stejne vyplivne v seznamu i (NULL) vektory.
char_cislo <- function(matice) {
    seznam <- eigen(matice, only.values = T)
    round(max(seznam$values), digits = 1)
}
char_cislo(x)

############################################Priklad 3###########################################
#Vytvorte funkci na geom. prumer
#Neresime nulove nebo zaporne hodnoty, coz by bylo zrejme narocnejsi na tvorbu.
geo_mean <- function(vektor, na.rm = T) {
    soucin <- 1
     for (i in 1:length(vektor)) {
        soucin <- soucin * vektor[i]
     }
    soucin^(1/length(vektor))
#   exp(log(soucin)/length(vektor)) - Mozna lehce elegantnejsi reseni.
}
koeficienty <- c(1.1, 1.12, 1.15, 1.3)
geo_mean(koeficienty)

#Pripadne jednoduse vzit jiz vytvorenou fci.
psych::geometric.mean(koeficienty, na.rm = T)
geo_mean(koeficienty) == psych::geometric.mean(koeficienty, na.rm = T)
