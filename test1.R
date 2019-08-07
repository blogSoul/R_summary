# https://m.blog.naver.com/PostView.nhn?blogId=leedk1110&logNo=220774824473&proxyReferer=https%3A%2F%2Fwww.google.com%2F
head(state.x77)
colnames(state.x77)

states <- as.data.frame(state.x77[,c("Murder","Population","Illiteracy","Income","Frost")])
head(states)

fit <- lm(Murder~Population+Illiteracy+Income+Frost,data = states) 
fit <- lm(Murder~.,data = states) 
fit
plot(Murder~.,data = states)

summary(fit)

fit2 <- lm(Murder~Population + Illiteracy, data = states)
summary(fit2)

#�̹����� �� �����Ϳ� income���� ������ ���� ����� ��������� �����ϴ� �������� �����
#ȸ�͸����� ���ս��Ѻ��ڽ��ϴ�.
rich <- NA
tmp <- cbind(states,rich)
head(tmp)
summary(tmp$Income) 
#��պ��� ������ 1 �ƴϸ� 0
tmp$rich[tmp$Income>4436] <- 1
tmp$rich[is.na(tmp$rich)] <- 0
head(tmp)

tmp$rich <- as.factor(tmp$rich)
fit <- lm(Murder~.,data = tmp) 
summary(fit)

#�̹����� rich��� �������� ������ ������ �������� ���߰������� ���� �˾ƺ��ڽ��ϴ�.
install.packages("psych")
library(psych)
install.packages("car")
library(car)
pairs.panels(tmp[names(tmp)])
#�� �׷������� ���ڴ� ������踦 ��Ÿ����, -1�� ������ ���� �������, 1�� ������ ���� ��������Դϴ�.
car::vif(fit) 
sqrt(car::vif(fit)) > 2
#'sqrt(car::vif(fit))' �� 2���� ũ�� ���߰������� �ִ� ���Դϴ�. 

#�ϳ��� �����ϴ� ���� �������� �ʾҴ� ������ ������ �� ���� �ֽ��ϴ�.
#����� ���� ����, ���� ������ �ֽ��ϴ�.
fit.con <- lm(Murder~1,data=tmp) 
fit.both <- step(fit.con,scope=list(lower=fit.con,upper=fit), direction = "both")
fit.both

#���������� ���ݱ��� ���� �𵨷� ���η�(y, ���Ӻ���)�� ������ ���ڽ��ϴ�.

pre_murder <- predict(fit.both, newdata = tmp) 
pre_murder <- as.data.frame(pre_murder)
pre_murder 

pre_murder <- predict(fit.both, newdata = tmp, interval = "confidence") 
pre_murder <- as.data.frame(pre_murder)
pre_murder

ttmp <- cbind(pre_murder,tmp$Murder) 
ttmp