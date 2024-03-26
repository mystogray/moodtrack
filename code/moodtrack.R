library(dplyr)
library(tidyr)
library(ggpubr)
library(ggplot2)
library(ggrepel)
library(glue)
library(MASS)
library(reshape)
library(reshape2)
library(showtext)
library(directlabels)
library(sysfonts)
library(ggsci)
library(ggalt)
library(MASS)
library(reshape)
library(reshape2)
library(tibble)
library(pheatmap)
library(corrplot)
library(ggheatmap)
library(RColorBrewer)

#Fonts
showtext_auto()
font_add_google("Roboto", "roboto")

df_mood = seq(as.Date("2023-01-01"),as.Date("2023-12-31"),1) %>%
  as.data.frame() %>%
  dplyr::rename("date"=".")
df_mood$month = format(df_mood$date, "%B")
emotions <- c("Ecstatic", "Happy", "Normal", "Sad", "Awful")
emotion_scores <- c(Ecstatic = 5, Happy = 4, Normal = 3, Sad = 2, Awful = 1)
df_mood$mood = sample(emotions, nrow(df_mood), replace = TRUE)
df_mood$mood = factor(df_mood$mood, levels = c("Awful", "Sad", "Normal", "Happy", "Ecstatic"))
df_mood$howmany = sample(c(1,2), nrow(df_mood), replace = TRUE)
activities = c("family","friends","streamer","sexual activity","music","movies","gaming","sleep","food","personal issues")
add_activity_columns <- function(df, activities) {
  for (i in 1:nrow(df)) {
    num_activities <- df$howmany[i]
    if (num_activities > 0) {
      for (j in 1:num_activities) {
        new_col_name <- paste0("activity_", j)
        df[i, new_col_name] <- sample(activities, 1)
      }
    }
  }
  return(df)
}
df_mood=add_activity_columns(df_mood, activities)
df_mood$score <- case_when(
  df_mood$mood == "Ecstatic" ~ emotion_scores["Ecstatic"],
  df_mood$mood == "Happy" ~ emotion_scores["Happy"],
  df_mood$mood == "Normal" ~ emotion_scores["Normal"],
  df_mood$mood == "Sad" ~ emotion_scores["Sad"],
  df_mood$mood == "Awful" ~ emotion_scores["Awful"]
)
df_mood_1 = df_mood

ggplot(df_mood,aes(x=mood,fill=mood)) +
  geom_bar() +
  scale_fill_npg() +
  theme(panel.border=element_rect(fill=NA, color='black'),
        legend.text=element_text(face = "italic"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title = element_text(size=18, face="bold"),
        plot.title = element_text(size=25, family="roboto", face="bold")) +
  labs(title="Cumulative Count of Each Mood", y="Count", x="Moods", fill=NULL) +
  ggeasy::easy_center_title()

df_mood_grpmonth=df_mood_1 %>%
  group_by(month) %>%
  summarize(mean_val = floor(mean(score)), sd = sd(score)) %>%
  mutate(month=factor(month,levels=month.name)) %>%
  mutate(mood=case_when(
    mean_val == "5" ~ emotions[1],
    mean_val == "4" ~ emotions[2],
    mean_val == "3" ~ emotions[3],
    mean_val == "2" ~ emotions[4],
    mean_val == "1" ~ emotions[5]
  )) %>%
  mutate(mood = factor(mood, levels = c("Awful", "Sad", "Normal", "Happy", "Ecstatic")))

ggplot(df_mood_grpmonth,aes(x=month,y=mood,group=1)) +
  geom_point(aes(group=1),color="grey",size=5) +
  geom_line(linewidth=.8) +
  scale_linetype_discrete() +
  theme_bw() +
  theme(
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14),
    axis.title = element_text(size=18, face="bold"),
    plot.title = element_text(size=25, family="roboto", face="bold")) +
  labs(title="Average Mood Throughout The Year", y="Mood", x="Month") +
  ggeasy::easy_center_title()

#Correlation
df_mood_corr_raw = melt(df_mood_1,id="mood",measure=c("activity_1","activity_2")) %>%
  filter(!is.na(value)) %>%
  dplyr::select(-variable) %>%
  cast(mood~value) %>%
  column_to_rownames("mood")

pheatmap(df_mood_corr_raw,
         cluster_rows = F,
         cluster_cols = F,
         color=colorRampPalette(brewer.pal(4, "PuBu"))(20))

ggheatmap(t(df_mood_corr_raw),
          levels_cols=rev(emotions),
          legendName=NULL,
          border="black") +
  scale_fill_material("deep-purple") +
  labs(title="Correlation Between Moods \nand Activities", fill=NULL) +
  theme(
    plot.title = element_text(size=25, family="roboto", face="bold"),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14)) +
  ggeasy::easy_center_title()

corr_mood = cor(df_mood_corr_raw,method="kendall")
ggheatmap(corr_mood,
          legendName=NULL,
          border="black") +
  scale_fill_material("green") +
  labs(title="Correlation Along Activities", fill=NULL) +
  theme(
    plot.title = element_text(size=25, family="roboto", face="bold"),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14)) +
  ggeasy::easy_center_title()

corrplot(corr_mood, title="Correlation Among Activities",method="circle")
