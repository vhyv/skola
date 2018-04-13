############################################# Priklad 1.1 ############################################################################

#Vypoctete funkci:
sqrt(log(3*sin(sqrt(cos(exp(-1)))), base = 3))

#Vypoctete dalsi funkci:
choose(max(c(10,min(c(10, abs(-25))))),   3)

#Dale vykreslete funkce:
#f(x) = sin(1/x);   x ∈ <0.1, 10>
sekvence1 <- seq(from = 0.1, to = 10, by = 0.0001)
plot(sekvence1, sin(1/sekvence1), type = 'l', xlab = 'x', ylab = 'sinus') +
    abline(a = 0, b = 0, lty = 2)

#f(x) = 2cos(x) + sin(2x)*cos(60x^2);   x ∈ <-10, 10>
sekvence2 <- seq(from = -10, to = 10, by = 0.001)
plot(sekvence2, 2*cos(sekvence2) + sin(2*sekvence2)*cos(60*sekvence2^2), type = 'l', xlab = 'x', ylab = 'fce')


############################################# Priklad 1.2 ############################################################################
X <- c(1,1,2,2,2,3,3,1,1,2,2,2,3,3,1,1,2,2,2,3,3,1,1,2,2,2,3,3,5)

#Veskere sude prvky vektoru X umocnete na druhou a odectete od nich 1.
X[X %% 2 == 0] <- X[X %% 2 == 0]^2 - 1          #Mozna trochu krkolomne reseni

#Nasledne vsechny prvky vektoru X celociselne delitelne tremi vydelte tremi.
X[X %% 3 == 0] <- X[X %% 3 == 0]/3

#Z nove vytvoreneho vektoru vypocitejte soucet a median prvku vektoru.
paste('Prumer je', round(mean(X), 4), 'a median je', median(X))

############################################# Priklad 1.3 ############################################################################
library(car)
#Prozkoumejte data a dokumentaci:
View(Blackmore)
#Pruzkum toho, jak pravidelne cvici nactilete divky, ktere byly hospitalizovany pro poruchu prijmu stravy. 
#id subjektu, vek, holik hodin tyne cvici a mezi jakou skupinu zkoumanych subjektu se radi.

#Spocitejte pocet duplicitnich hodnot pro kazdy sloupec tohoto datoveho souboru
duplikaty <- data.frame(sloupec = character() , pocet_duplikatu = numeric(), stringsAsFactors = F)

for (i in 1:ncol(Blackmore)) {
    duplikaty[i, 1] <- as.character(colnames(Blackmore)[i])
    duplikaty[i, 2] <- sum(duplicated(Blackmore[,i]))
}
duplikaty

#Vypocitejte prumerny pocet hodin venovanych cviceni behem jednoho tydne pouze pro subjekty do 35 let patrici do skupiny pacient.
mean(Blackmore$exercise[Blackmore$age > 35 & Blackmore$group == 'patient'])
sum(Blackmore$age > 35) #Pocet subjektu starsich 35 let je v data framu 0, proto prumer vyse vyplivne NA result.

#Vypocitejte maximalni a minimalni pocet hodin venovanych cviceni behem jednoho tydne zvlast pro skupinu control a skupinu patient.
#Existuje milion zpusobu, jak na to. Misto prostych max() a min() funkci jsem se naucil toto celkem zajimave a sympaticke reseni.
cvicba <- cbind(aggregate(Blackmore$exercise, list(Blackmore$group), max),
                aggregate(Blackmore$exercise, list(Blackmore$group), min)[2])
names(cvicba) <- c('Skupina', 'Nejvyssi cvicba', 'Nejnizsi cvicba')
cvicba

#Zkonstruujte krabickovy graf poctu hodin venovanych cviceni behem jednoho tydne zvlast pro skupiny control a patient.
boxplot(Blackmore$exercise ~ Blackmore$group, xlab = 'Skupina', ylab = 'Pocet hodin cvicby tydne', 
        col = c('tomato', 'salmon'))
#pripadne pokud chceme videt pouze krabice a vousy, bez outlieru:
boxplot(Blackmore$exercise ~ Blackmore$group, xlab = 'Skupina', ylab = 'Pocet hodin cvicby tydne',
        outline = F,
        col = c('powderblue', 'cornsilk'))

############################################### Priklad 1.4 ####################################################
#Vytvorte list obsahujici dva prvky - Spolecnost 1 a Spolecnost 2.

novylist <- list(c('Spolecnost 1', 'Spolecnost 2'))

novylist['Spolecnost 1'] <- list(c('Jméno společnosti:' = 'Firma 1', 
                                 'Forma:' = 'Akciovka',
                                 'Počet zaměstnanců:' = 666,
                                 'Tuzemská firma:' = T))
novylist['Spolecnost 2'] <- list(c('Jméno společnosti:' = 'Firma 2', 
                                   'Forma:' = 'Akciovka',
                                   'Počet zaměstnanců:' = 871,
                                   'Tuzemská firma:' = F))

#Pridejte k obema spolecnostem udaj o pruměrnem veku: X ~ N(mi = 28, rozptyl = 16)
#Dost jsem zapasil uz jen se samotnym pridavanim prvku (hlavne pri snaze pouzit funkci append() - marne). 
#Neprisel jsem na to, jak pridat stejnou hodnotu obema listum naraz.

novylist[['Spolecnost 1']] <- c(novylist[['Spolecnost 1']], 'Průměrný věk' = round(rnorm(n = 1, mean = 28, sd = 4), 2))
novylist[['Spolecnost 2']] <- c(novylist[['Spolecnost 2']], 'Průměrný věk' = round(rnorm(n = 1, mean = 28, sd = 4), 2))
novylist            

#Rozdíl mezi vektorem a listem:
#Vektor = jednoduchy, vsechny prvky musi byt stejneho typu
#List = Rozsahlejsi, v podstate obsahuje libovolne mnozstvi vektoru, kdy kazdy vektor muze byt jineho typu.

################################################ Priklad 1.5 #########################################################
#Vytvorte algoritmus, ktery usporada libovolne zadany vektor.
vek <- c(6,5,3,1,8,7,2,4,15,45,12,121,84,1,3,7,17)

seradit <- function(x) {
provizor <- numeric()
for (i in length(x):2) {
    a <- 1
    while(a < i) {
        
        if (x[a] > x[a+1]) {
            provizor <- x[a]
            x[a] <- x[a+1]
            x[a+1] <- provizor
        } 
        a <- a + 1 
    }
}
print(x)    
}
seradit(vek)

################################################ Priklad 1.6 ###########################################################
#Vytvorte algoritmus, ktery nalezne nejvetsi spolecny delitel dvou libovolne zadanych cisel 
#Pouziti Euklidova algoritmu
delitel <- function(a, b) {
    if (a == b) {
        return(paste('Cisla jsou stejna, jejich nejvyssi spolecny delitel je', a))
    }
    prvni <- numeric()
    druhe <- numeric()
    pomocne <- numeric()
    
    if (a > b) {
        prvni <- a
        druhe <- b
    } else if (b > a) {
        prvni <- b
        druhe <- a
    } 
while (prvni %% druhe != 0) {
    pomocne <- prvni %% druhe
    prvni <- druhe
    druhe <- pomocne
}
    return(paste('Nejvyssi spolecny delitel cisel', a, 'a', b, 'je', druhe))
}
delitel(500,20)

############################################### Priklad 1.7 ############################################################
#Vytvorte funkci, ktera nalezne z libovolne zadaneho vektoru m-te nejnizsi cislo.
#Zde jsem vyuzil uz vyse vytvorenou funkci serazovaciho algoritmu, kdy uz staci jenom zvolit poradi daneho prvku ve vektoru.
hledacek <- function(vektor, poradi) {
    x <- vektor
    provizor <- numeric()
    
    for (i in length(x):2) {
        a <- 1
        while(a < i) {
            
            if (x[a] > x[a+1]) {
                provizor <- x[a]
                x[a] <- x[a+1]
                x[a+1] <- provizor
            } 
            a <- a + 1 
        }
    }
    return(paste(poradi, '. nejnizsi hodnota je: ', x[poradi], sep = ''))
}
hledacek(X, 5)

############################################### Priklad 1.8 ###########################################################
#Vytvorte funkci, která dokaze najit reseni libovolne kvadraticke rovnice. Pevne definujte vstup.
kvadraticka_rce <- function(acko, becko, cecko) {
x <- numeric()
x1 <- numeric()
x2 <- numeric()
diskriminant <- becko^2 - 4*acko*cecko

if (diskriminant == 0) {
    x <- (-becko)/2*acko
    return(paste('Rovnice má jedno řešení:', x))
} else if (diskriminant > 0){
    x1 <- round(((-becko) + sqrt(diskriminant))/(2*acko), 4)
    x2 <- round(((-becko) - sqrt(diskriminant))/(2*acko), 4)
    
    return(paste('Rovnice má dvě řešení:', x1, 'a', x2 ))
} else if (diskriminant < 0) {
    return(paste('Rovnice nemá v oboru reálných čísel řešení.'))
}
}

kvadraticka_rce(2, 9, 5)


############################################# Priklad 2.1 #############################################################
#Za pomoci metody inverzni transformace vytvorte generator nahodne veliciny z daneho rozdeleni.

hustota <- function(cislo, acko, becko) {
    1/(cislo*((log(base = exp(1), x = becko )) - log(x = acko, base = exp(1))))
}

distro <- function(cislo, acko, becko) {
    
    
    
}

hustota(0.5,4,3)
