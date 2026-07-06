# BPapp
<img src="DefaultIcon@2x.png" alt="App Icon" width="114">

Blood Pressure recording app (w/ SQLite under the hood), for iOS 6 devices. Part of 30-day Objective-C challenge, available at [my blog page](https://qmng.notion.site/objective-c-challenge).
## Features
- Record data w/ date
- Add comments to the logging entry
- Delete unwanted entries

## Info
This repo references the tutorial of [@profgustin on YouTube](https://www.youtube.com/playlist?list=PLLk083vNjCXYTT_oLTDlGq2gelsILnLIT). 
Some SQLite elements was further secured, and avoided bad practices such as the use of [stringWithFormat](https://github.com/quangmng/BPapp/tree/no-stringWithFormat) which can be vulnerable to SQL Injection attacks ([@robertmryan in comments](https://youtu.be/uxoeZ-1yCMc)).
