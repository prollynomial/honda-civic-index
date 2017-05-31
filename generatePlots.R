args <- commandArgs(TRUE)

if (length(args) != 3) {
	print("usage: Rscript generatePlots.R path/to/civics.csv path/to/output.svg cityname")
	stop()
}

infile <- args[1]
outfile <- args[2]
cityname <- args[3]

civics <- read.csv(infile)
options(scipen=1)

# Bound price, kms, and year
maxPrice <- 30000
minYear <- 1990
minKms <- 1000
maxKms <- 400000
civics <- civics[civics$price <= maxPrice, ]
civics <- civics[civics$year >= minYear, ]
civics <- civics[civics$kms >= minKms & civics$kms <= maxKms, ]
civics <- civics[!is.na(civics$kms) & !is.na(civics$price) & !is.na(civics$kms), ]

svg(outfile)

par(mfrow=c(3, 2), oma=c(0,0,5,0))

# Quick facts
plot(c(0, 1), c(0, 1), ann=F, bty='n', type='n', xaxt='n', yaxt='n')

formatPrice <- function (price) {
	format(price, format="f", big.mark=",", digits=2)
}

ref2005 <- civics[civics$year == 2005 & civics$kms >= 234000 & civics$kms <= 286000, c('price')]
ref2010 <- civics[civics$year == 2010 & civics$kms >= 144000 & civics$kms <= 176000, c('price')]
ref2015 <- civics[civics$year == 2015 & civics$kms >= 54000 & civics$kms <= 66000, c('price')]
info <- paste0("Volume: ", nrow(civics),
			"\nCap: $", formatPrice(sum(civics$price)),
			"\nReference Civic 2005: $", formatPrice(mean(ref2005)), " (", length(ref2005), ")",
			"\nReference Civic 2010: $", formatPrice(mean(ref2010)), " (", length(ref2010), ")",
			"\nReference Civic 2015: $", formatPrice(mean(ref2015)), " (", length(ref2015), ")")

text(x=0.5, y=0.5, info, cex=1.5, col="black")

# Price distribution
hist(civics$price, probability=T, xlim=c(0, maxPrice), breaks=seq(0, maxPrice, 1000), col="gray", border="white", main="Price distribution")
d <- density(civics$price)
lines(d, col="red")

# Year distribution
hist(civics$year, probability=T, xlim=c(minYear, 2020), breaks=seq(minYear, 2020, 1), col="gray", border="white", main="Model year distribution")
d <- density(civics$year)
lines(d, col="red")

# KMs distribution
hist(civics$kms, probability=T, xlim=c(0, maxKms), breaks=seq(0, maxKms, 10000), col="gray", border="white", main="KMs distribution")
d <- density(civics$kms)
lines(d, col="red")

# Price as a function of year
plot(price ~ year, data=civics, xlim=c(minYear, 2020), ylim=c(0, maxPrice), col="gray", border="white")
title("Price as a function of model year")

# Price as a function of kms
plot(price ~ kms, data=civics, xlim=c(0, maxKms), ylim=c(0, maxPrice), col="gray", border="white")
title("Price as a function of kilometers")

title(paste0("Honda Civic Index - ", cityname), outer=T, cex.main="1.8")

dev.off()
