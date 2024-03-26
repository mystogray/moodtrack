# Mood Swing be Making Me Swinging My Head Against The Wall
An analysis of random-generated mood dataset all-day throughout 2023

## Result
### How Happy Was I?
I calculated the average mood by giving score to each emotions. There are 5 emotions: Ecstatic, Happy, Normal, Sad, and Awful, each has the score of 5, 4, 3,... respectively.\
![plot](https://github.com/mystogray/mystogray_porto/blob/main/docs/assets/porto_mood_count.svg)
Having the average of a decimal number, I rounded it to the decimal below (`floor`).\
Turns out, I was not happy throughout 2023, as my dominant moods were Normal and Sad. My lowest consecutive months are August–September, while my highest is in the next 3 months.\
![plot](https://github.com/mystogray/mystogray_porto/blob/main/docs/assets/porto_mood_avg.svg)

### What Activities Impact Which Emotions?
In the dataset, there is a random one or two random activities that caused certain emotion. I analyzed which activity correlates to each emotion by counting the number of cells of each combination of emotions and activity.\
Then, I plot it using heatmap.\
From the heatmap, the activity which correlates to ecstatic or happy emotion are friends, gaming, streamer, sexual activity, and sleep. Sexual activity gave me the most happiness with 16 occasions where I was ecstatic because of this.\
Meanwhile, movies and personal issues are the two activities that caused me to have sad or awful emotion. Surprisingly, sexual activity are the third highest activity that cause me to have awful emotions.\
![plot](https://github.com/mystogray/mystogray_porto/blob/main/docs/assets/porto_mood_corr.svg)

### Are Some Activities Usually Go Together?
Sometimes, there are patterns to multiple activities that correlates to my mood. I used Kendall's correlation test to identify the correlation among each activities, whether there is a pattern or not.\
Family and Personal Issues have a negative correlation. Because we already know that personal issues is the dominant activity in awful emotion, it means that family tends to not cause the same emotion as personal issues.\
Other than that, gaming and streaming have a positive correlation, as I usually game while watching Twitch or YouTube.\
Food correlates positively with sleep but correlates negatively with friends, which means that I rarely go out to eat with my friends and I sleep before or after eating.\
![plot](https://github.com/mystogray/mystogray_porto/blob/main/docs/assets/porto_mood_corrplotactivities.svg)
