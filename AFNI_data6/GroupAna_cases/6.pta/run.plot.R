# plot predicted profile from run.pta1.txt
dd <- read.table('result1-prediction.txt', header=T)
require(ggplot2)
dev.new(width=6, height=4)
ggplot(data=dd, aes(x=layer, y=prediction))+
    geom_line() + theme_bw() +
    scale_x_continuous(breaks = unique(dd$layer))+
    geom_ribbon(aes(ymin=prediction-se, ymax=prediction+se), linetype=2, alpha=0.1)+ylab('y')

# plot predicted profile from run.pta2.txt
dd <- read.table('result2-prediction.txt', header=T)
require(ggplot2)
dev.new(width=6, height=4)
ggplot(data=dd, aes(x=layer, y=prediction))+
    geom_line() + theme_bw() +
    scale_x_continuous(breaks = unique(dd$layer))+
    geom_ribbon(aes(ymin=prediction-se, ymax=prediction+se), linetype=2, alpha=0.1)+ylab('y')
