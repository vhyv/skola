###################################Priklad 1############################################
#Prozkoumejte soubor data_mc.csv
#
#Soubor obsahuje Headers, na prvnim radku.
#Jak jsou oddeleny decimals nelze urcit, jelikoz soubor zadne takove hodnoty neobsahuje
#Separator je strednik (semicolon) 
#Chybejici pozorovani jsou vynechana uplne, nejsou nijak znacena
moje_data <- read.table(file = "data_mc.csv", header = T, sep = ";",
                      na.strings = "")
View(moje_data)
summary(moje_data)

#Spocitejte prumernou vahu zvlast pro kazdou krevni skupinu.
tapply(X = moje_data$weight, INDEX = moje_data$krevní.skupina, FUN = mean, na.rm = T)

#Naleznete pocet radku, kde nechybi ani jedno pozorovani
nrow(moje_data[complete.cases(moje_data),])

#Pocet radku, kde jsou alespon dve chybejici pozorovani
sum(rowSums(is.na(moje_data)) >=2)

#Kolik jednotlive sloupce obsahuji chybejicich pozorovani
#Asi podobne jako vyse
rowSums(is.na(moje_data))
#Pripadne
moje_data$pocetNA <- rowSums(is.na(moje_data))

#Pouze radky, ktere neobsahuji chybejici pozorovani a vypoctete maxima sloupcu.
#vlozim data a sloupce, u kterych ma cenu pocitat maxima.

maxima_sloupcu <- function(moje_data, moje_sloupce){
    sloupce <- colnames(moje_data[moje_sloupce]) #jmena sloupcu, ktera budu pocitat.
    maxima <- numeric(length(sloupce))  #Pripravim si prazdny vektor k naplneni 
    names(maxima) <- sloupce
    
    for (i in 1:length(sloupce)){   #Vektor naplnim 
        maxima[i] <- max(moje_data[complete.cases(moje_data), sloupce[i]])
        }
    maxima
}
maxima_sloupcu(moje_data, 3:6)
#Nebo taky:
maxima_sloupcu(moje_data, c("weight", "height"))
