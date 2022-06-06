# install.packages('OneR')
# install.packages('dplyr')
library('OneR')
library('dplyr')

# Importing the dataset
youtube_dataset = read.csv('Youtube.csv')

fit_likes = lm(Views~Likes, data = youtube_dataset)
fit_shares = lm(Views~Shares, data = youtube_dataset)
fit_subscribers = lm(Views~Subscribers, data = youtube_dataset)
fit_Watch_Time = lm(Views~Watch.time..hours., data = youtube_dataset)
fit_impressions = lm(Views~Impressions, data = youtube_dataset)

summary(fit_shares)
summary(fit_likes)
summary(fit_Watch_Time)
summary(fit_subscribers)
summary(fit_impressions)

plot(youtube_dataset$Likes, youtube_dataset$Views,
     main='Scatterplot', xlab='Likes', ylab='Views',
     pch=19)
abline(fit_likes, col='red', lwd=2)

predict(fit_likes, newdata = data.frame(Likes=25000))
predict(fit_likes, newdata = data.frame(Likes=26000))

plot(youtube_dataset$Shares, youtube_dataset$Views,
     main='Scatterplot', xlab='Shares', ylab='Views',
     pch=19)
abline(fit_shares, col='red', lwd=2)

predict(fit_shares, newdata = data.frame(Shares=2200))
predict(fit_shares, newdata = data.frame(Shares=2800))


plot(youtube_dataset$Subscribers, youtube_dataset$Views,
     main='Scatterplot', xlab='Subscribers', ylab='Views',
     pch=19)
abline(fit_subscribers, col='red', lwd=2)

predict(fit_subscribers, newdata = data.frame(Subscribers=7500))
predict(fit_subscribers, newdata = data.frame(Subscribers=8500))
